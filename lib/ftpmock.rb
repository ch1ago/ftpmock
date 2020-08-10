require 'pathname'
require 'ftpmock/version'

Dir['lib/ftpmock/{utils,core,helpers,proxies}/*.rb'].each do |f|
  load f
end

module Ftpmock
  class Error < StandardError; end
  class GetNotFetched < Error; end
  class PutFileNotFound < Error; end
  class PutLocalDiffersFromCache < Error; end

  def self.on!(&block)
    NetFtpProxy.on! do
      NetSftpProxy.on!(&block)
    end
  end

  def self.off!
    NetFtpProxy.off!
    NetSftpProxy.off!
  end
end
