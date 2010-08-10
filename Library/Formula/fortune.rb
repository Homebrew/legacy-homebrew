require 'formula'

class Fortune <Formula
  url 'http://ftp.ibiblio.org/pub/linux/games/amusements/fortune/fortune-mod-9708.tar.gz'
  homepage 'http://ftp.ibiblio.org/pub/linux/games/amusements/fortune/!INDEX.html'
  md5 '81a87a44f9d94b0809dfc2b7b140a379'

  def options
    [['--no-offensive', "Don't install potentially offenive fortune files"]]
  end

  def install
    ENV.deparallelize

    inreplace 'Makefile' do |contents|
      contents.change_make_var! 'FORTDIR', "/usr/local/bin" # indeed, correct
      contents.gsub! '/usr/local/man', '/usr/local/share/man'
      contents.gsub! '/usr/local', prefix
      contents.change_make_var! 'CC', ENV.cc
      # OS X only supports POSIX regexes
      contents.change_make_var! 'REGEXDEFS', '-DHAVE_REGEX_H -DPOSIX_REGEX'
      # Don't install offensive fortunes
      contents.change_make_var! 'OFFENSIVE', '0' if ARGV.include? '--no-offensive'
    end

    system "make install"
  end
end
