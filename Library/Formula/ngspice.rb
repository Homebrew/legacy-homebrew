require 'formula'

class Ngspice < Formula
  homepage 'http://ngspice.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/ngspice/ng-spice-rework/24/ngspice-24.tar.gz'
  sha1 'a6bb0e65c1c07d48f1d3e4df44fc17f6262952eb'

  option "without-xspice", "Build without x-spice extensions"

  depends_on :x11

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-editline=yes
      --enable-x
    ]
    args << "--enable-xspice" unless build.include? "without-xspice"

    system "./configure", *args
    system "make install"
  end

  def caveats;
    "Note: ngspice is an X11 application."
 end
end
