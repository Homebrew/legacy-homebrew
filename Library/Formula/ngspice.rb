require 'formula'

class Ngspice < Formula
  url 'http://downloads.sourceforge.net/project/ngspice/ng-spice-rework/24/ngspice-24.tar.gz'
  homepage 'http://ngspice.sourceforge.net/'
  md5 'e9ed7092da3e3005aebd892996b2bd5f'

  def options
  [
    ["--without-xspice", "Builds with x-spice extensions"],
  ]
  end

  def install
    argv =
    [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--with-editline=yes",
      "--enable-x",
      "--enable-xspice"
    ]
    argv.delete("--enable-xspice") if ARGV.include? "--without-xspice"

    system "./configure", *argv
    system "make install"
  end

  def caveats
    "Note: ngspice is an X11 application."
    "Note: use --without-xspice to build without xspice compatibilty."
 end
end
