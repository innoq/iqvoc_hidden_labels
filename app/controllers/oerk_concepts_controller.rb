# encoding: UTF-8
class OerkConceptsController < ConceptsController

  def destroy
    if Iqvoc::Concept.base_class.by_origin(params[:id]).unpublished.any?
      @new_concept = Iqvoc::Concept.base_class.by_origin(params[:id]).unpublished.last!

      authorize! :destroy, @new_concept

      if @new_concept.destroy
        published_concept = Iqvoc::Concept.base_class.published.by_origin(@new_concept.origin).first
        flash[:success] = I18n.t('txt.controllers.concept_versions.delete')
        redirect_to published_concept.present? ? concept_path(id: published_concept.origin) : dashboard_path
      else
        flash[:success] = I18n.t('txt.controllers.concept_versions.delete_error')
        redirect_to concept_path(published: 0, id: @new_concept)
      end
    else
      @concept = Iqvoc::Concept.base_class.by_origin(params[:id]).published.first

      authorize! :destroy, @concept

      if catch(:abort){@concept.destroy}
        flash[:success] = I18n.t('txt.controllers.concepts.delete')
        redirect_to dashboard_path
      else
        flash[:success] = I18n.t('txt.controllers.concepts.dependent_delete_error')
        redirect_to concept_path(id: @concept)
      end
    end
  end
end