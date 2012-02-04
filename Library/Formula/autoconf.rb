require 'formula'

class Autoconf <Formula
  url 'http://ftp.gnu.org/gnu/autoconf/autoconf-2.68.tar.gz'
  homepage 'http://savannah.gnu.org/projects/autoconf/'
  md5 'c3b5247592ce694f7097873aa07d66fe'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

