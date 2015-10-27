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
  s.add_dependency 'ice_cube_cron', '>= 0.0.3'

  ##
  # Development Dependencies
  #
  s.add_development_dependency 'rake'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
end
