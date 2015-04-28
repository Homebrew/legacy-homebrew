# Wrapper for the real, vendored i18n gem, plus some Homebrew-specific helpers

$LOAD_PATH << File.expand_path('vendor', File.dirname(__FILE__))

require 'i18n'
I18n.load_path << Dir[File.expand_path('locales/*.yml', File.dirname(__FILE__))]

module Homebrew
  module I18n
    class << self
      # Determine the desired locale based on the Darwin locale set in the LANG
      # and LC_ALL environment variables, and return a Ruby symbol that can be
      # given to I18n.default_locale=.
      def locale_from_env
        locale = nil
        env_locale = ENV['LANG'] || ENV['LC_ALL']
        if env_locale
          env_locale = env_locale.gsub('_', '-')
          available_locales = ::I18n.available_locales.map {|loc_sym| loc_sym.to_s}
          locales_to_try(env_locale).each do |try_locale|
            if available_locales.include?(try_locale)
              locale = try_locale
              break
            end
          end
          locale.to_sym if locale
        end
      end

      # Given a locale of the form xx-XX-XX.xxxx, return a list of locales to
      # try, from most to least specific (xx-XX-XX.xxxx, xx-XX-XX, xx-XX, xx)
      def locales_to_try(locale)
        locales = []
        locale_scratchpad = locale.clone
        if (locale_scratchpad.index('.'))
          locales << locale_scratchpad
          locale_scratchpad = locale_scratchpad.split('.')[0]
        end

        locale_parts = locale_scratchpad.split('-')
        loop do
          locales << locale_parts.join('-')
          locale_parts.pop
          break if locale_parts.empty?
        end

        locales
      end
    end
  end
end

::I18n.default_locale = Homebrew::I18n::locale_from_env || :'en-US'
::I18n.enforce_available_locales = false

def t(*args); I18n.t(*args); end
def l(*args); I18n.l(*args); end
