Iqvoc.config.register_settings({
  'title' => 'iQvoc',
  'languages.pref_labeling' => ['en', 'de'],
  'languages.further_labelings.Labeling::SKOS::AltLabel' => ['en', 'de'],
  'languages.further_labelings.Labeling::SKOS::HiddenLabel' => ['en', 'de'],
  'languages.notes' => ['en', 'de'],
  'performance.unbounded_hierarchy' => false,
  'sources.iqvoc' => ['']
})

Iqvoc.host_namespace = Iqvoc::OeRK

Iqvoc.ability_class_name = 'OerkAbility'

Iqvoc::Concept.base_class_name = 'Concept::OERK::Base'
Iqvoc::Concept.notation_class_names = []

Iqvoc.searchable_class_names = {
  'Labeling::SKOS::Base' => 'labels',
  'Labeling::SKOS::PrefLabel' => 'pref_labels',
  'Labeling::SKOS::HiddenLabel' => 'hidden_labels',
  'Note::Base' => 'notes'
}

