require 'pathname'

require 'ftpmock/configuration'
require 'ftpmock/version'

module Ftpmock
  class Error < StandardError; end
  class CodeError < Error; end
  class GetNotFetched < Error; end
  class PutFileNotFound < Error; end
  class PutLocalDiffersFromCache < Error; end

  autoload :Cache, 'ftpmock/core/cache'
  # autoload :Configuration, 'ftpmock/core/configuration'

  autoload :GetHelper,  'ftpmock/helpers/get_helper'
  autoload :ListHelper, 'ftpmock/helpers/list_helper'
  autoload :PathHelper, 'ftpmock/helpers/path_helper'
  autoload :PutHelper,  'ftpmock/helpers/put_helper'

  autoload :NetFtpProxy, 'ftpmock/proxies/net_ftp_proxy'
  autoload :NetSftpProxy, 'ftpmock/proxies/net_sftp_proxy'
  autoload :MethodMissingMixin, 'ftpmock/proxies/method_missing_mixin'

  autoload :ColorUtils, 'ftpmock/utils/color_utils'
  autoload :StringUtils, 'ftpmock/utils/string_utils'
  autoload :VerboseUtils, 'ftpmock/utils/verbose_utils'

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
