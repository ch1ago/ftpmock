module Ftpmock
  class Cache
    attr_reader :credentials, :configuration

    def initialize(configuration, credentials)
      @configuration = configuration
      @credentials = credentials
      @chdir = nil
    end

    def path
      @path ||= Pathname("#{configuration.path}/#{path_dir}")
    end

    def path_dir
      StringUtils.parameterize(credentials.map(&:to_s).join('_'))
    end

    def chdir(dirname = nil)
      return @chdir if dirname.nil?

      @chdir = PathHelper.join(@chdir, dirname)
    end
  end
end
