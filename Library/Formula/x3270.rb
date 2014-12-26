require "formula"

class X3270 < Formula
  homepage "http://x3270.bgp.nu/"
  url "https://downloads.sourceforge.net/project/x3270/x3270/3.3.15ga8/suite3270-3.3.15ga8-src.tgz"
  sha1 "c53d4cb7bd961f4114539495c46ffdab45303f77"

  bottle do
    sha1 "bc56bef330ed5179723cb3cda669492b89b8a705" => :yosemite
    sha1 "1e317cde1f0bf755057b6189972f57b8432ccce6" => :mavericks
    sha1 "f31aa130ccc0bd377309fdc1b91c4fa8a5004ba4" => :mountain_lion
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
