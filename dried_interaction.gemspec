
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dried_interaction/version"

Gem::Specification.new do |spec|
  spec.name          = "dried_interaction"
  spec.version       = DriedInteraction::VERSION
  spec.authors       = ["gl-pv"]
  spec.email         = ["gleeb812812@yandex.ru"]

  spec.summary       = %q{PlainQuery is a simple gem that helps you write clear and flexible query objects}
  spec.description   = %q{PlainQuery helps in decomposing your fat ActiveRecord models and keeping your code slim and readable by extracting complex SQL queries or scopes into the separated classes that are easy to write, read and use.}
  spec.homepage      = "https://github.com/gl-pv/dried_interaction"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/gl-pv/dried_interaction"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'dry-initializer', '~> 3.0'
  spec.add_dependency 'dry-monads', '~> 1.0'
  spec.add_dependency 'dry-matcher', '~> 0.7'
  spec.add_dependency 'dry-validation', '~> 1.2'
  spec.add_dependency 'dry-schema', '~> 1.0'

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
