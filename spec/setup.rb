require 'bundler/setup'

require 'simplecov'

SimpleCov.start do
  add_group 'Utils', [
    'lib/ftpmock/utils',
    'spec/ftpmock/utils'
  ]
  add_group 'Core', [
    'lib/ftpmock/core',
    'spec/ftpmock/core'
  ]
  add_group 'Helpers', [
    'lib/ftpmock/helpers',
    'spec/ftpmock/helpers'
  ]
  add_group 'Proxies', [
    'lib/ftpmock/proxies',
    'spec/ftpmock/proxies'
  ]
end
