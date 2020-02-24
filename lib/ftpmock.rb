require 'ftpmock/version'

Dir['lib/ftpmock/{core,proxies}/*.rb'].each do |f|
  load f
end

module Ftpmock
  class Error < StandardError; end

  def self.on!(&block)
    NetFtpProxy.on!(&block)
  end

  def self.off!
    NetFtpProxy.off!
  end
end
