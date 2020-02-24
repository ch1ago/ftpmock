# https://github.com/net-ssh/net-sftp

module Ftpmock
  class NetSftpProxy
    # Stubbers

    Real = begin
             Net::SFTP
           rescue NameError
             nil
           end

    # inspired by https://github.com/bblimke/webmock/blob/master/lib/webmock/http_lib_caches/net_http.rb
    def self.on!
      unless Real
        yield
        return
      end

      Net.send(:remove_const, :SFTP)
      Net.const_set(:SFTP, self)
      if block_given?
        yield
        off!
      end
    end

    def self.off!
      return unless Real

      Net.send(:remove_const, :SFTP)
      Net.const_set(:SFTP, Real)
    end

    # Instance Methods

    def initialize(configuration: Ftpmock.configuration)
      @configuration = configuration
    end

    # def self.start(*)
    #   i = new
    #   yield i
    # end

    def real
      @real ||= Real.new
    end
  end
end
