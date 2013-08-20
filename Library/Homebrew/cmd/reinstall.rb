require 'cmd/uninstall'
require 'cmd/install'

module Homebrew extend self
  def reinstall
    # At first save the named formulae and remove them from ARGV
    named = ARGV.named
    ARGV.delete_if { |arg| named.include? arg }
    clean_ARGV = ARGV.clone

    # Add the used_options for each named formula separately so
    # that the options apply to the right formula.
    named.each do |name|
      ARGV.replace(clean_ARGV)
      ARGV << name
      tab = Tab.for_name(name)
      tab.used_options.each { |option| ARGV << option.to_s }
      ARGV << '--build-bottle' if tab.built_as_bottle
      # Todo: Be as smart as upgrade to restore the old state if reinstall fails.
      self.uninstall
      oh1 "Reinstalling #{name} #{ARGV.options_only*' '}"
      self.install
    end
  end
end
