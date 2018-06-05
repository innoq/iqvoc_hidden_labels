# encoding: UTF-8
require File.join(File.expand_path(File.dirname(__FILE__)), '../test_helper')
class ConceptTest < ActiveSupport::TestCase

  def create_concept_with_sub_concept
    @bear_concept = RDFAPI.devour 'bear', 'a', 'skos:Concept'
    RDFAPI.devour @bear_concept, 'skos:prefLabel', '"Bear"@en'
    @bear_concept.save

    @concept = RDFAPI.devour 'forest', 'a', 'skos:Concept'
    RDFAPI.devour @concept, 'skos:prefLabel', '"Forest"@en'
    RDFAPI.devour @concept, 'skos:broader', @bear_concept
    @concept.save
  end

  test 'allow for duplicate concept prefLabels' do
    bear_one = RDFAPI.devour 'bear_one', 'a', 'skos:Concept'
    RDFAPI.devour bear_one, 'skos:prefLabel', '"Bear"@en'

    assert bear_one.save
    assert bear_one.publishable?

    bear_two = RDFAPI.devour 'bear_two', 'a', 'skos:Concept'
    RDFAPI.devour bear_two, 'skos:prefLabel', '"Bear"@en'

    assert bear_two.save
    assert bear_two.publishable?
  end

  test 'additional_info implementation' do
    create_concept_with_sub_concept

    assert_equal "", @bear_concept.additional_info
    assert_equal "< Bear", @concept.additional_info

    @bear_concept.update(top_term: true)
    assert_equal "Top Term", @bear_concept.additional_info
  end

  test 'delete concept without narrower' do
    bear_concept = RDFAPI.devour 'bear', 'a', 'skos:Concept'
    RDFAPI.devour bear_concept, 'skos:prefLabel', '"Bear"@en'
    bear_concept.save

    assert bear_concept.narrowest_destroy
  end

  test 'conception deletion with narrower fails' do
    create_concept_with_sub_concept

    assert_not @bear_concept.narrowest_destroy
  end

end