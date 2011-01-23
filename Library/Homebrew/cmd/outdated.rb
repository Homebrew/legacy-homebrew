require 'formula'

module Homebrew extend self
  def outdated
    outdated_brews.each do |keg, name, version|
      if $stdout.tty? and not ARGV.flag? '--quiet'
        versions = keg.cd{ Dir['*'] }.join(', ')
        puts "#{name} (#{versions} < #{version})"
      else
        puts name
      end
    end
  end

  def outdated_brews
    HOMEBREW_CELLAR.subdirs.map do |rack|
      # Skip kegs with no versions installed
      next unless rack.subdirs

      # Skip HEAD formulae, consider them "evergreen"
      next if rack.subdirs.map{ |keg| keg.basename.to_s }.include? "HEAD"

      name = rack.basename.to_s
      f = Formula.factory name rescue nil
      [rack, name, f.version] if f and not f.installed?
    end.compact
  end
end