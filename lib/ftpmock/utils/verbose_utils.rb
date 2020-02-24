module Ftpmock
  module VerboseUtils
    module_function

    def warn(string)
      Kernel.warn string
    end

    def puts(string = '')
      Kernel.puts string
    end

    def alert(tag, content, color)
      content = ColorUtils.colorize(content, color)
      output = ColorUtils.bold "#{tag} -> #{content}"
      puts output
    end
  end
end
