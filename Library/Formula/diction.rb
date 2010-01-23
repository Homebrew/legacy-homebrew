require 'formula'

class Diction <Formula
  url 'http://ftp.gnu.org/gnu/diction/diction-1.11.tar.gz'
  homepage 'http://www.gnu.org/software/diction/'
  md5 '4cbdb115c976d7141f54b223df28012e'

  aka 'style'

  def install
      configure_args = [
          "--prefix=#{prefix}",
          "--disable-debug",
          "--disable-dependency-tracking",
      ]
    system "./configure", *configure_args
    system "make install"
  end
end
