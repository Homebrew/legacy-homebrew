require 'brewkit'

class Glpk <Formula
  url 'http://ftp.gnu.org/gnu/glpk/glpk-4.39.tar.gz'
  homepage 'http://www.gnu.org/software/glpk/'
  md5 '95f276ef6c94c6de1eb689f161f525f3'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
