module Ftpmock
  class Cache
    attr_reader :credentials, :configuration

    def initialize(configuration, credentials)
      @configuration = configuration
      @credentials = credentials
    end

    def path
      @path ||= Pathname("#{configuration.path}/#{path_dir}")
    end

    def path_dir
      StringUtils.parameterize(credentials.map(&:to_s).join('_'))
    end
  end
end
