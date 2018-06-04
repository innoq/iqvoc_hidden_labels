# encoding: UTF-8
class Concept::OERK::Base < Concept::SKOS::Base

  before_destroy do |concept|
    if concept.narrower_relations.any?
      throw(:abort)
    else
      Iqvoc::Concept.base_class.by_origin(concept.origin).unpublished.destroy_all
    end
  end

  def additional_info
    map_broaders = broader_relations.any? ? "< #{broader_relations.map{|br| br.target.pref_label.value}.join(", ")}" : ""
    "#{top_term ? self.class.human_attribute_name("top_term") : map_broaders}"
  end

  def unique_pref_labels

  end

end