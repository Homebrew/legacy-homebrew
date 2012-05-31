require 'formula'

class Ngspice < Formula
  homepage 'http://ngspice.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/ngspice/ng-spice-rework/24/ngspice-24.tar.gz'
  md5 'e9ed7092da3e3005aebd892996b2bd5f'

  def options
    [["--without-xspice", "Build without x-spice extensions"]]
  end

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-editline=yes",
            "--enable-x"]
    args << "--enable-xspice" unless ARGV.include? "--without-xspice"

    system "./configure", *args
    system "make install"
  end

  def caveats;
    "Note: ngspice is an X11 application."
 end
end
