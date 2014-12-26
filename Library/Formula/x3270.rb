require "formula"

class X3270 < Formula
  homepage "http://x3270.bgp.nu/"
  url "https://downloads.sourceforge.net/project/x3270/x3270/3.3.15ga8/suite3270-3.3.15ga8-src.tgz"
  sha1 "c53d4cb7bd961f4114539495c46ffdab45303f77"

  bottle do
    sha1 "81e5aabb7141ecb9f16957a6df43455d36fe56fe" => :yosemite
    sha1 "6332bbab671a5846ce947b8307296912d6e9b311" => :mavericks
    sha1 "d41624098de6a1df6b9bf7ce599682d26b351039" => :mountain_lion
  end

  depends_on :x11
  depends_on "openssl"

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
