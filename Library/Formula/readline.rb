require 'brewkit'

class Readline <Formula
  @url='ftp://ftp.cwru.edu/pub/bash/readline-6.0.tar.gz'
  @homepage='http://tiswww.case.edu/php/chet/readline/rltop.html'
  @md5='b7f65a48add447693be6e86f04a63019'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make install"
  end
end
