Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_print_quote'
  s.version     = '0.60.1'
  s.summary     = 'Add gem summary here'
  s.description = 'Add (optional) gem description here'
  s.required_ruby_version = '>= 1.8.7'

  s.author            = 'Bara Cek'
  s.email             = 'baracek@yahoo.com'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency('spree_print_settings', '>= 0.60.1')
  s.add_dependency('spree_core', '>= 0.60.1')
  s.add_dependency('prawn', '= 0.8.4')
end
