require 'formula'

class Screen <Formula
  homepage 'http://www.gnu.org/software/screen/'
  url 'http://ftp.gnu.org/gnu/screen/screen-4.0.3.tar.gz'
  md5 '8506fd205028a96c741e4037de6e3c42'

  def patches
    # fixes stropts.h compile error (patch from MacPorts: https://trac.macports.org/ticket/13009)
    { :p0 => "https://trac.macports.org/raw-attachment/ticket/13009/patch-pty.c" }
  end

  def install
    args = ["--disable-debug", "--prefix=#{prefix}", "--mandir=#{man}", "--infodir=#{info}"]

    system "./configure", *args
    system "make install"
  end
end
