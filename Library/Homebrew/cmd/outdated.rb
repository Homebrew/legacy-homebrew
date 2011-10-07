require 'formula'

module Homebrew extend self
  def outdated
    outdated_brews.each do |f|
      if $stdout.tty? and not ARGV.flag? '--quiet'
        versions = f.rack.cd{ Dir['*'] }.join(', ')
        puts "#{f.name} (#{versions} < #{f.version})"
      else
        puts f.name
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
      f if f and not f.installed?
    end.compact
  end
end
