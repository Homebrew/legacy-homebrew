require "formula"

class X3270 < Formula
  homepage "http://x3270.bgp.nu/"
  url "https://downloads.sourceforge.net/project/x3270/x3270/3.3.15ga5/suite3270-3.3.15ga5-src.tgz"
  sha1 "7f918e21c9134ce4bccb7e0f661763f9f18946ee"

  bottle do
    sha1 "df5f6dd221c372fac63d45236c6cc3b3b4ab16e3" => :mavericks
    sha1 "cfc5b618501b3eacfaf1b68abf3d3bcf6b767b50" => :mountain_lion
    sha1 "b0e808139b1c4f00fc5be8e2263a42b62a46f1c6" => :lion
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
