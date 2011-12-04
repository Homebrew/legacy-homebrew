module Homebrew extend self
  def link
    require 'keg'
    kegs = ARGV.formulae.map do |f|
      path = f.installed_prefix
      unless path.directory?
        dirs = f.rack.children.select(&:directory?) rescue []
        raise NoSuchKegError.new(name) if dirs.length == 0
        raise MultipleVersionsInstalledError.new(name) if dirs.length > 1
        path = dirs.first
      end
      keg = Keg.new path
    end
    kegs.each do |keg|
      print "Linking #{keg}... "
      begin
        puts "#{keg.link} symlinks created"
      rescue Exception
        puts
        raise
      end
    end
  end
end
