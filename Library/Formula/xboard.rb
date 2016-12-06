require 'formula'

class Xboard < Formula
  url 'http://git.savannah.gnu.org/cgit/xboard.git/snapshot/xboard-4.5.3.20110822.tar.gz'
  homepage 'http://www.tim-mann.org/xboard.html'
  md5 'adb8dc417499fbe23a57d69d82da3ce1'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'

  def install
    args = ["--prefix=#{prefix}",
            "--x-include=/usr/X11/include",
            "--x-lib=/usr/X11/lib",
            "--disable-zippy"]

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make install"
  end
end
