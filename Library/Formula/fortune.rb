require 'formula'

class Fortune <Formula
  url 'http://ftp.ibiblio.org/pub/linux/games/amusements/fortune/fortune-mod-9708.tar.gz'
  homepage 'http://ftp.ibiblio.org/pub/linux/games/amusements/fortune/!INDEX.html'
  md5 '81a87a44f9d94b0809dfc2b7b140a379'

  def options
    [
      ['--no-offensive', "Don't install potentially offenive fortune files"]
    ]
  end

  def install
    ENV.deparallelize

    inreplace 'Makefile', 'FORTDIR=/usr/local/games', "FORTDIR=/usr/local/bin"
    inreplace 'Makefile', '/usr/local', prefix
    inreplace 'Makefile', 'CC=gcc', "CC=#{ENV.cc}"
    # OS X only supports POSIX regexes
    inreplace 'Makefile', 'REGEXDEFS=-DHAVE_REGEX_H -DBSD_REGEX', 'REGEXDEFS=-DHAVE_REGEX_H -DPOSIX_REGEX'

    # Don't install offensive fortunes
    inreplace 'Makefile', 'OFFENSIVE=1', 'OFFENSIVE=0' if ARGV.include? '--no-offensive'

    system "make install"
  end
end
