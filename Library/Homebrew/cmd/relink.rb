module Homebrew extend self
  def relink
    ARGV.kegs.each do |keg|
      print "Linking #{keg}... "
      begin
        puts "#{keg.unlink} symlinks removed, #{keg.link} symlinks created"
      rescue Exception
        puts
        raise
      end
    end
  end
end
