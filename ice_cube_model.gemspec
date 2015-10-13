# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'ice_cube_model/version'

Gem::Specification.new do |s|
  s.name        = 'ice_cube_model'
  s.version     = IceCubeModel::VERSION
  s.authors     = ['Matt Nichols']
  s.email       = ['matt@nichols.name']
  s.homepage    = 'https://github.com/mattnichols/ice_cube_model'
  s.summary     = 'Extend any class with ice_cube (calendar repeating events) capabilities.'
  s.description = 'Add ice_cube methods to classes (e.g. active_record, active_model).'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']

  ##
  # Dependencies
  #
  s.add_dependency 'ice_cube', '= 0.13.0'
  s.add_dependency 'activesupport', '>= 3.0.0'

  ##
  # Development Dependencies
  #
  s.add_development_dependency 'rake'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-rubocop'
  s.add_development_dependency 'spring'
  s.add_development_dependency 'spring-commands-rspec'
end
