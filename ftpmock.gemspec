lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ftpmock/version'

Gem::Specification.new do |spec|
  spec.name          = 'ftpmock'
  spec.version       = Ftpmock::VERSION
  spec.authors       = ['James Pinto']
  spec.email         = ['thejamespinto@gmail.com']

  spec.summary       = 'Test your FTP calls offline.'
  spec.description   = 'Just like VCR and WebMock, but for FTP.'
  spec.homepage      = 'https://github.com/thejamespinto/ftpmock'
  spec.license       = 'MIT'

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem
  # that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0")
                     .reject { |f| f.match(%r{^(images|test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'net-sftp'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov'

  spec.add_dependency 'diffy', '~> 3.0'
end
