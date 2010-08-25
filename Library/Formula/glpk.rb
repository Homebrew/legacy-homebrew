require 'formula'

class Glpk <Formula
  url 'http://ftp.gnu.org/gnu/glpk/glpk-4.42.tar.gz'
  homepage 'http://www.gnu.org/software/glpk/'
  md5 '9091a60c4c44a16a149375f7a6cce158'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
