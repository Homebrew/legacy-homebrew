module Homebrew extend self
  def link
    raise KegUnspecifiedError if ARGV.named.empty?

    ARGV.kegs.each do |keg|
      print "Linking #{keg}... "
      puts if ARGV.verbose?
      begin
        puts "#{keg.link} symlinks created"
      rescue Exception
        puts
        raise
      end
    end
  end
end
