# encoding: UTF-8
class Concept::OERK::Base < Concept::SKOS::Base

  def narrowest_destroy
    if self.narrower_relations.any?
      false
    else
      Iqvoc::Concept.base_class.by_origin(self.origin).destroy_all
    end
  end

  def additional_info
    map_broaders = broader_relations.any? ? "< #{broader_relations.map{|br| br.target.pref_label.value}.join(", ")}" : ""
    "#{top_term ? self.class.human_attribute_name("top_term") : map_broaders}"
  end

  def unique_pref_labels

  end

end