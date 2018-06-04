# encoding: UTF-8
class OerkCollectionsController < CollectionsController

  def show
    published = params[:published] == '1' || !params[:published]
    scope = Iqvoc::Collection.base_class.by_origin(params[:id])

    if published
      scope = scope.published
      @new_collection_version = Iqvoc::Collection.base_class.by_origin(params[:id]).unpublished.last
    else
      scope = scope.unpublished
    end

    @collection = scope.last!
    authorize! :read, @collection

    # When in single query mode, AR handles ALL includes to be loaded by that
    # one query. We don't want that! So let's do it manually :-)
    ActiveRecord::Associations::Preloader.new.preload(@collection,
      [:pref_labels,
        { members: { target: [:pref_labels] + Iqvoc::Collection.base_class.default_includes } }])

    respond_to do |format|
      format.html { published ? render('show_published') : render('show_unpublished') }
      format.any(:rdf, :ttl, :nt) if can?(:export, Concept::Base)
    end
  end

  private

  def concept_params
    params.require(:concept).permit!
  end

  def build_note_relations
    @collection.note_skos_definitions.build if @collection.note_skos_definitions.empty?
  end
end