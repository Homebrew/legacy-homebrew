require 'formula'

class Ngspice < Formula
  homepage 'http://ngspice.sourceforge.net/'
  url 'http://sourceforge.net/projects/ngspice/files/ng-spice-rework/25/ngspice-25.tar.gz'
  sha1 '745c3c32385b7d5c808836e393fe7699f8568860'

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
