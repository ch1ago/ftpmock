module Ftpmock
  module ColorUtils
    module_function

    # gem colorize, 'string'.bold.black.on_light_yellow
    def highlight(string)
      "\e[1;30;103m#{string}\e[0m"
    end

    def colorize(string, color)
      case color
      when :red
        "\e[0;91;49m#{string}\e[0m"
      when :yellow
        "\e[0;93;49m#{string}\e[0m"
      when :green
        "\e[0;92;49m#{string}\e[0m"
      else
        string
      end
    end

    def bold(string)
      "\e[1;39;49m#{string}\e[0m"
    end
  end
end
