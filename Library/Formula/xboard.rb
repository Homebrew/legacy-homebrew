require 'formula'

class Xboard < Formula
  url 'http://ftpmirror.gnu.org/xboard/xboard-4.5.3.tar.gz'
  homepage 'http://www.gnu.org/software/xboard/'
  md5 '48a623643fc6ad2b3d1963165bca76dc'

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
