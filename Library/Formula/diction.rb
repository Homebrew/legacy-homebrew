require 'formula'

class Diction <Formula
  url 'http://ftp.gnu.org/gnu/diction/diction-1.11.tar.gz'
  homepage 'http://www.gnu.org/software/diction/'
  md5 '4cbdb115c976d7141f54b223df28012e'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
