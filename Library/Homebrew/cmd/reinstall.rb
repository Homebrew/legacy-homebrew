require 'cmd/unlink'
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
      self.unlink
      ARGV.kegs.each do |keg|
        puts "#{keg.to_s}"
        File.rename keg.to_s, keg.to_s + '.reinstall'
      end

      begin
        self.install
        ARGV.kegs.each do |keg|
          FileUtils.rm_rf keg.to_s + '.reinstall'
        end
      rescue Exception
        ARGV.kegs.each do |keg|
          if Dir[keg.to_s + '.reinstall'] != nil
            File.rename keg.to_s + '.reinstall', keg.to_s
            keg.link(OpenStruct.new)
          end
        end
      end
    end
  end
end
