module Ftpmock
  module StringUtils
    module_function

    def all_present?(*strings)
      strings.all? { |string| present?(string) }
    end

    def present?(string)
      return string.present? if string.respond_to?(:present?)

      !string.to_s.strip.empty?
    end

    # Inspired by from gems/activesupport-5.2.3
    # /lib/active_support/inflector/transliterate.rb
    def parameterize(string, separator: '-')
      string.to_s
            .gsub(/[^a-z0-9\-_]+/i, separator)
            .downcase
    end
  end
end
