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

    def get(remotefile, localfile = File.basename(remotefile))
      tag = _get_tag_for(remotefile)

      if GetHelper.read(path, chdir, remotefile, localfile)
        _get_alert_hit(tag, localfile)
        return
      end

      _get_alert_miss(tag)
      yield

      if GetHelper.fetched?(localfile)
        _get_alert_storing(tag, localfile)
        GetHelper.write(path, chdir, remotefile, localfile)
      else
        _get_raise_localfile_not_fetched(remotefile, localfile)
      end
    end

    def _get_tag_for(remotefile)
      tag = "ftpmock.cache.get '#{remotefile}'"
      tag += ", chdir: '#{chdir}'" if chdir
      tag
    end

    def _get_alert_hit(tag, localfile)
      _alert tag, "hit! (#{localfile})"
    end

    def _get_alert_miss(tag)
      _alert tag, 'miss!', :yellow
    end

    def _get_alert_storing(tag, localfile)
      _alert tag, "storing #{localfile}"
    end

    def _get_raise_localfile_not_fetched(remotefile, localfile)
      msg = "FTP GET '#{remotefile}' should have created '#{localfile}'"
      msg = "#{msg}, but didn't."
      raise GetNotFetched, msg
    end
  end
end
