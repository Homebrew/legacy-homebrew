require "formula"

class X3270 < Formula
  homepage "http://x3270.bgp.nu/"
  url "https://downloads.sourceforge.net/project/x3270/x3270/3.3.15ga5/suite3270-3.3.15ga5-src.tgz"
  sha1 "7f918e21c9134ce4bccb7e0f661763f9f18946ee"

  bottle do
    sha1 "c8d06fd2d78e89f65976c45c99b69e8b3f585102" => :yosemite
    sha1 "305257a2615698a57341793cbda367588244faf8" => :mavericks
    sha1 "c35fdab2f4223da207164eff643313b2ee291b37" => :mountain_lion
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
