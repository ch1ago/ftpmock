module Ftpmock
  module PutHelper
    module_function

    def cached?(cache_path, remotefile)
      path = path_for(cache_path, remotefile)
      path.exist?
    end

    def exist?(localfile)
      File.exist?(localfile)
    end

    def write(cache_path, localfile, remotefile)
      path = path_for(cache_path, remotefile)
      FileUtils.cp(localfile, path)
    end

    # Array
    def compare(cache_path, localfile, remotefile)
      return [] unless cached?(cache_path, remotefile)

      path = path_for(cache_path, remotefile)
      diff = StringUtils.diff(localfile, path)
      diff.split("\n")
    end

    # def expire(cache_path, remotefile)
    #   path = path_for(cache_path, remotefile)
    #   path.exist? && path.delete
    # end

    def path_for(cache_path, remotefile)
      path = cache_path.join('put')
      FileUtils.mkdir_p(path)
      path.join(remotefile.tr('/', '-'))
    end
  end
end
