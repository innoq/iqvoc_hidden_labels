# encoding: UTF-8
class OerkConceptsController < ConceptsController

  def show
    get_concept
    authorize! :read, @concept

    @datasets = datasets_as_json
    respond_to do |format|
      format.html do

        jobs = @concept.jobs
        if jobs.any?
          match_classes = Iqvoc::Concept.reverse_match_class_names

          @jobs = jobs.map do |j|
            handler = YAML.load(j.handler)
            match_class_name = match_classes.key(handler.match_class)
            reverse_match_class_name = match_class_name.constantize.reverse_match_class_name
            reverse_match_class_label = reverse_match_class_name.constantize.rdf_predicate.camelize if reverse_match_class_name

            result = {response_error: j.error_message}
            result[:subject] = handler.subject
            result[:type] = handler.type
            result[:match_class] = reverse_match_class_label || reverse_match_class_name
            result
          end
        end

        # When in single query mode, AR handles ALL includes to be loaded by that
        # one query. We don't want that! So let's do it manually :-)
        ActiveRecord::Associations::Preloader.new.preload(@concept,
          Iqvoc::Concept.base_class.default_includes + [collection_members: { collection: :labels },
          broader_relations: { target: [:pref_labels, :broader_relations] },
          narrower_relations: { target: [:pref_labels, :narrower_relations] }])

        @published ? render('show_published') : render('show_unpublished')
      end
      format.json do
        # When in single query mode, AR handles ALL includes to be loaded by that
        # one query. We don't want that! So let's do it manually :-)
        ActiveRecord::Associations::Preloader.new.preload(@concept, [:labels,
            { relations: { target: [:labelings, :relations] } }])

        published_relations = lambda { |concept|
          return concept.relations.includes(:target).
            merge(Iqvoc::Concept.base_class.published).references(:concepts)
        }
        concept_data = {
          origin: @concept.origin,
          labels: @concept.labelings.map { |ln| labeling_as_json(ln) },
          relations: published_relations.call(@concept).map { |relation|
            concept = relation.target
            {
              origin: concept.origin,
              labels: concept.labelings.map { |ln| labeling_as_json(ln) },
              relations: published_relations.call(concept).count
            }
          },
          links: [
            { rel: 'self', href: concept_url(@concept, format: nil), method: 'get' },
            { rel: 'add_match', href: add_match_url(@concept, lang: nil), method: 'patch' },
            { rel: 'remove_match', href: remove_match_url(@concept, lang: nil), method: 'patch' }
          ]
        }
        # FIXME: use jbuilder instead???
        render json: concept_data
      end
      format.any(:rdf, :ttl, :nt) if can?(:export, Concept::Base)
    end
  end

  def destroy
    if Iqvoc::Concept.base_class.by_origin(params[:id]).unpublished.any?
      @new_concept = Iqvoc::Concept.base_class.by_origin(params[:id]).unpublished.last!

      authorize! :destroy, @new_concept

      if @new_concept.destroy
        published_concept = Iqvoc::Concept.base_class.published.by_origin(@new_concept.origin).first
        flash[:success] = I18n.t('txt.controllers.concept_versions.delete')
        redirect_to published_concept.present? ? concept_path(id: published_concept.origin) : dashboard_path
      else
        flash[:error] = I18n.t('txt.controllers.concept_versions.delete_error')
        redirect_to concept_path(published: 0, id: @new_concept)
      end
    else
      @concept = Iqvoc::Concept.base_class.by_origin(params[:id]).published.first

      authorize! :destroy, @concept

      if @concept.narrowest_destroy
        flash[:success] = I18n.t('txt.controllers.concepts.delete')
        redirect_to dashboard_path
      else
        flash[:error] = I18n.t('txt.controllers.concepts.dependent_delete_error')
        redirect_to concept_path(id: @concept)
      end
    end
  end
end