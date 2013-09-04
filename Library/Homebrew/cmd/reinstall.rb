require 'cmd/uninstall'
require 'cmd/install'

module Homebrew extend self
  def reinstall
    # At first save the named formulae and remove them from ARGV
    named = ARGV.named
    ARGV.delete_if { |arg| named.include? arg }
    # We add --force because then uninstall always succeeds and so reinstall
    # works for formulae not yet installed.
    ARGV << "--force"
    clean_ARGV = ARGV.clone

    # Add the used_options for each named formula separately so
    # that the options apply to the right formula.
    named.each do |name|
      ARGV.replace(clean_ARGV)
      ARGV << name
      tab = Tab.for_name(name)
      tab.used_options.each { |option| ARGV << option.to_s }
      if tab.built_as_bottle and not tab.poured_from_bottle
        ARGV << '--build-bottle'
      end
      # Todo: Be as smart as upgrade to restore the old state if reinstall fails.
      self.uninstall
      # Don't display --force in options; user didn't request it so a bit scary.
      options_only = ARGV.options_only
      options_only.delete "--force"
      oh1 "Reinstalling #{name} #{options_only*' '}"
      self.install
    end
  end
end
