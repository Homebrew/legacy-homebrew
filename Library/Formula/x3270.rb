require "formula"

class X3270 < Formula
  homepage "http://x3270.bgp.nu/"
  url "https://downloads.sourceforge.net/project/x3270/x3270/3.3.15ga7/suite3270-3.3.15ga7-src.tgz"
  sha1 "fa6bce67248861bbd255159af7c0a505bf661830"

  bottle do
    sha1 "9c468a256bb675508326eb64a1c01d797606c776" => :yosemite
    sha1 "556ca35df10981f820c361befef2ed48f6e4b957" => :mavericks
    sha1 "7fb2901635816b138b97dd445c2c85d57919e40a" => :mountain_lion
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
