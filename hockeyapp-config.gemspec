# -*- encoding: utf-8 -*-

Version = "0.1"

Gem::Specification.new do |spec|
  spec.name = 'hockeyapp-config'
  spec.summary = 'Small HockeyApp configuration used by Propeller'
  spec.description = "Small HockeyApp configuration used by Propeller"
  spec.author = 'Clay Allsopp'
  spec.email = 'clay@usepropeller.com'
  spec.homepage = 'https://github.com/usepropeller/hockeyapp-config'
  spec.version = Version

  spec.add_dependency "hockeyapp"

  files = []
  files << 'LICENSE'
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files = files
end
