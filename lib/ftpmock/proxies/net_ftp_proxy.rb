# https://apidock.com/ruby/Net/FTP
require 'net/ftp'

module Ftpmock
  class NetFtpProxy
    # Stubbers

    Real = begin
             Net::FTP
           rescue NameError
             nil
           end

    # inspired by https://github.com/bblimke/webmock/blob/master/lib/webmock/http_lib_caches/net_http.rb
    def self.on!
      unless Real
        yield
        return
      end

      Net.send(:remove_const, :FTP)
      Net.const_set(:FTP, self)
      if block_given?
        yield
        off!
      end
    end

    def self.off!
      return unless Real

      Net.send(:remove_const, :FTP)
      Net.const_set(:FTP, Real)
    end

    # Instance Methods

    def initialize(configuration: Ftpmock.configuration)
      @configuration = configuration
    end

    def real
      @real ||= Real.new
    end

    attr_writer :cache, :real
    attr_reader :configuration,
                :host,
                :port,
                :username,
                :password

    # connection methods

    def connect(host, port = 21)
      @real_connected = false
      @host = host
      @port = port

      StringUtils.all_present?(host, port) || _raise_not_connected

      @cache_connected = true
      true
    end

    def login(username, password)
      @cache = nil
      @real_logged = false
      @username = username
      @password = password

      _init_cache

      @cache_logged = true
      true
    end

    def _real_connect_and_login
      @cache_connected || _raise_not_connected
      @cache_logged || _raise_not_connected

      @real_connected || real.connect(*_real_connect_args)
      @real_connected = true

      @real_logged || real.login(*_real_login_args)
      @real_logged = true

      if @chdir
        @real.chdir(@chdir)
        @chdir = nil
      end
    end

    def _real_connect_args
      [host, port]
    end

    def _real_login_args
      [username, password].select { |string| StringUtils.present?(string) }
    end

    def _init_cache
      credentials = [host, port, username, password]
      @cache = Cache.new(configuration, credentials)
    end

    def cache
      @cache || _raise_not_connected
    end

    def _raise_not_connected
      raise(Net::FTPConnectionError, 'not connected')
    end

    # directory methods

    # https://docs.ruby-lang.org/en/2.0.0/Net/FTP.html#method-i-chdir
    def chdir(dirname = nil)
      cache.chdir(dirname)
    end

    def pwd
      chdir
    end

    def getdir
      chdir
    end

    # list methods

    def list(*args)
      cache.list(*args) do
        _real_connect_and_login
        real.list(*args)
      end
    end

    # get methods

    def get(remotefile, localfile = File.basename(remotefile))
      cache.get(remotefile, localfile) do
        _real_connect_and_login
        real.get(remotefile, localfile)
      end

      true
    end

    def gettextfile(remotefile, localfile = File.basename(remotefile))
      cache.get(remotefile, localfile) do
        _real_connect_and_login
        real.gettextfile(remotefile, localfile)
      end

      true
    end

    def getbinaryfile(remotefile, localfile = File.basename(remotefile))
      cache.get(remotefile, localfile) do
        _real_connect_and_login
        real.getbinaryfile(remotefile, localfile)
      end

      true
    end

    # put methods

    # TODO: block
    # https://docs.ruby-lang.org/en/2.0.0/Net/FTP.html#method-i-put
    def put(localfile, remotefile = File.basename(localfile))
      cache.put(localfile, remotefile) do
        _real_connect_and_login
        real.put(localfile, remotefile)
      end

      true
    end

    # TODO: block
    def puttextfile(localfile, remotefile = File.basename(localfile))
      cache.put(localfile, remotefile) do
        _real_connect_and_login
        real.puttextfile(localfile, remotefile)
      end

      true
    end

    # TODO: block
    def putbinaryfile(localfile, remotefile = File.basename(localfile))
      cache.put(localfile, remotefile) do
        _real_connect_and_login
        real.putbinaryfile(localfile, remotefile)
      end

      true
    end

<<<<<<< HEAD
    # TODO: Methods Not Implemented

    # abort
    # acct
    # binary
    # binary=
    # close
    # closed?
    # debug_mode
    # debug_mode=
    # delete
    # help
    # last_response
    # last_response_code
    # mdtm
    # mkdir
    # mlsd
    # mlst
    # mon_enter
    # mon_exit
    # mon_locked?
    # mon_owned?
    # mon_synchronize
    # mon_try_enter
    # mtime
    # new_cond
    # nlst
    # noop
    # open_timeout
    # open_timeout=
    # passive
    # passive=
    # quit
    # read_timeout
    # read_timeout=
    # rename
    # resume
    # resume=
    # retrbinary
    # retrlines
    # return_code
    # return_code=
    # rmdir
    # sendcmd
    # set_socket
    # site
    # size
    # ssl_handshake_timeout
    # ssl_handshake_timeout=
    # status
    # storbinary
    # storlines
    # system
    # voidcmd
    # welcome
    include MethodMissingMixin
  end
end
