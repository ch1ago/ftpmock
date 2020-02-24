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

    def _alert(tag, content, color = :green)
      configuration.verbose && VerboseUtils.alert(tag, content, color)
    end

    def chdir(dirname = nil)
      return @chdir if dirname.nil?

      original = @chdir
      @chdir = PathHelper.join(@chdir, dirname)

      _chdir_alert(dirname, original, @chdir)
      @chdir
    end

    def _chdir_alert(dirname, old_chdir, new_chdir)
      tag = "ftpmock.cache.chdir '#{dirname}'"

      _alert tag, "changed from '#{old_chdir}' to '#{new_chdir}'", :green
    end

    def list(*args)
      key = args.join(',')
      tag = _list_tag_for(key)

      list = ListHelper.read(path, chdir, key)
      _list_alert_hit(tag, list)
      return list if list

      _list_alert_miss(tag)
      list = yield

      _list_alert_storing(tag, list)
      ListHelper.write(path, chdir, key, list)

      list
    end

    def _list_tag_for(key)
      tag = "ftpmock.cache.list '#{key}'"
      tag += ", chdir: '#{chdir}'" if chdir
      tag
    end

    def _list_alert_hit(tag, list)
      list.nil? || _alert(tag, "hit! (#{list.size} lines)")
    end

    def _list_alert_miss(tag)
      _alert tag, 'miss!', :yellow
    end

    def _list_alert_storing(tag, list)
      _alert tag, "storing #{list.size} lines!"
    end
  end
end
