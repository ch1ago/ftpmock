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

    # inspired by https://github.com/bblimke/webmock/blob/master/lib/webmock/http_lib_adapters/net_http.rb
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

    attr_reader :configuration,
                :real

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
