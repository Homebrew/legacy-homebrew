require 'formula'

class Fortune < Formula
  homepage 'http://ftp.ibiblio.org/pub/linux/games/amusements/fortune/!INDEX.html'
  url 'http://ftp.ibiblio.org/pub/linux/games/amusements/fortune/fortune-mod-9708.tar.gz'
  sha1 '9f96a00dbf5d2c6b0e7324af0eae988ce6adc5ad'

  option 'no-offensive', "Don't install potentially offensive fortune files"

  def install
    ENV.deparallelize

    inreplace 'Makefile' do |s|
      # Use our selected compiler
      s.change_make_var! 'CC', ENV.cc

      # Change these first two folders to the correct location in /usr/local...
      s.change_make_var! 'FORTDIR', "/usr/local/bin"
      s.gsub! '/usr/local/man', '/usr/local/share/man'
      # Now change all /usr/local at once to the prefix
      s.gsub! '/usr/local', prefix

      # OS X only supports POSIX regexes
      s.change_make_var! 'REGEXDEFS', '-DHAVE_REGEX_H -DPOSIX_REGEX'
      # Don't install offensive fortunes
      s.change_make_var! 'OFFENSIVE', '0' if build.include? 'no-offensive'
    end
    system "make install"
  end
end
