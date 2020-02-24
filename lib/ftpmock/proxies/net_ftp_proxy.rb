# https://apidock.com/ruby/Net/FTP
require 'net/ftp'

module Ftpmock
  class NetFtpProxy
    # Stubbers

    Real = Net::FTP

    # inspired by https://github.com/bblimke/webmock/blob/master/lib/webmock/http_lib_adapters/net_http.rb
    def self.on!
      Net.send(:remove_const, :FTP)
      Net.const_set(:FTP, self)
      if block_given?
        yield
        off!
      end
    end

    def self.off!
      Net.send(:remove_const, :FTP)
      Net.const_set(:FTP, Real)
    end

    # Instance Methods

    def initialize(configuration: Ftpmock.configuration)
      @configuration = configuration
    end

    attr_reader :configuration,
                :real
  end
end
