require "formula"

class X3270 < Formula
  homepage "http://x3270.bgp.nu/"
  url "https://downloads.sourceforge.net/project/x3270/x3270/3.3.14ga11/suite3270-3.3.14ga11-src.tgz"
  sha1 "23bf5b29a2c3c10b935b66a95f666de350ae9c2d"

  bottle do
    sha1 "8e63062663062dbd4412f65a6ef4d8de7a6b793e" => :mavericks
    sha1 "183083f571154a57dccfef53f8e5d025f6947064" => :mountain_lion
    sha1 "70241dff845889ef68a58a18aa542c62aee01929" => :lion
  end

  depends_on :x11

  option "with-c3270", "Include c3270 (curses-based version)"
  option "with-s3270", "Include s3270 (displayless version)"
  option "with-tcl3270", "Include tcl3270 (integrated with Tcl)"
  option "with-pr3287", "Include pr3287 (printer emulation)"

  def make_directory(directory)
    cd directory do
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make install"
      system "make install.man"
    end
  end

  def install
    make_directory "x3270-3.3"
    make_directory "c3270-3.3" if build.with? "c3270"
    make_directory "pr3287-3.3" if build.with? "pr3287"
    make_directory "s3270-3.3" if build.with? "s3270"
    make_directory "tcl3270-3.3" if build.with? "tcl3270"
  end
end
