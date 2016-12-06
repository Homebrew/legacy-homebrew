require 'formula'

class ShUtils <Formula
  url 'http://ftp.gnu.org/old-gnu/sh-utils/sh-utils-2.0.tar.gz'
  homepage 'http://www.gnu.org/software/shellutils/'
  md5 '5e78d1d48ca563ca77e96b22406c4aaf'

  def install
    cp "/usr/share/libtool/config/config.guess", "."
    cp "/usr/share/libtool/config/config.sub", "."
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"

    system "make install"
  end
end
