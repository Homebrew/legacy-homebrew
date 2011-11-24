module Homebrew extend self
  def link
    ARGV.kegs.each do |keg|
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
