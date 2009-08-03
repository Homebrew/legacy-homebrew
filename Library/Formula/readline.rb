require 'brewkit'

class Readline <Formula
  @url='ftp://ftp.gnu.org/gnu/readline/readline-5.2.tar.gz'
  @homepage='http://tiswww.case.edu/php/chet/readline/rltop.html'
  @md5='e39331f32ad14009b9ff49cc10c5e751'

  def patches
    (1..14).collect {|n| "ftp://ftp.gnu.org/gnu/readline/readline-5.2-patches/readline52-%03d"%n}
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make install"
  end
end
