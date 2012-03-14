require 'formula'

class Xboard < Formula
  url 'http://ftpmirror.gnu.org/xboard/xboard-4.6.0.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/xboard/xboard-4.6.0.tar.gz'
  homepage 'http://www.gnu.org/software/xboard/'
  md5 '80b445539bef9950cbc2df9ed8f21f0d'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'

  def install
    args = ["--prefix=#{prefix}",
            "--x-include=/usr/X11/include",
            "--x-lib=/usr/X11/lib",
            "--disable-zippy"]

    system "./configure", *args
    system "make"
    system "make install"
  end
end
