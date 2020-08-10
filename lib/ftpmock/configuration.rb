module Ftpmock
  module_function

  def configure
    yield configuration
  end

  def configuration
    @configuration ||= Configuration.new
  end

  class Configuration
    attr_writer :path
    attr_accessor :verbose

    def initialize(path: nil, verbose: true)
      @path = path
      @verbose = verbose
    end

    def path
      @path ||= "#{test_dir}/ftp_records"
    end

    def test_dir
      rspec? ? 'spec' : 'test'
    end

    def rspec?
      defined?(RSpec)
    end
  end
end
