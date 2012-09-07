require 'formula'

class Ngspice < Formula
  homepage 'http://ngspice.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/ngspice/ng-spice-rework/24/ngspice-24.tar.gz'
  sha1 'a6bb0e65c1c07d48f1d3e4df44fc17f6262952eb'

  option "with-x", "Build with X support"
  option "without-xspice", "Build without x-spice extensions"

  depends_on :x11 if MacOS::X11.installed? or build.include? "with-x"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-editline=yes
    ]
    args << "--enable-x" if build.include? "with-x"
    args << "--enable-xspice" unless build.include? "without-xspice"

    system "./configure", *args
    system "make install"
  end

  def test
    system "#{bin}/ngspice", "-v"
  end
end
