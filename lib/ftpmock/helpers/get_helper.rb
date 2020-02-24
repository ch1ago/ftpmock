module Ftpmock
  module GetHelper
    module_function

    # reads from cache to localfile
    #
    # true/false
    def read(cache_path, chdir, remotefile, localfile)
      # chdir =
      remotefile = PathHelper.join(PathHelper.simplify(chdir), remotefile).to_s
      # localfile = PathHelper.join(chdir, localfile).to_s

      cached_path = path_for(cache_path, remotefile)

      File.exist?(cached_path) && FileUtils.cp(cached_path, localfile)

      fetched?(localfile)
    end

    # writes to cache from localfile
    def write(cache_path, chdir, remotefile, localfile)
      return false unless File.exist?(localfile)

      # chdir =
      remotefile = PathHelper.join(PathHelper.simplify(chdir), remotefile).to_s
      # localfile = PathHelper.join(chdir, localfile).to_s

      cached_path = path_for(cache_path, remotefile)
      FileUtils.cp(localfile, cached_path)

      File.exist?(cached_path)
    end

    def fetched?(localfile)
      File.exist?(localfile)
    end

    def path_for(cache_path, remotefile)
      path = cache_path.join('get')
      remotefile = PathHelper.simplify(remotefile)
      ret = path.join(remotefile)
      FileUtils.mkdir_p(ret.dirname.to_s)
      ret
    end
  end
end
