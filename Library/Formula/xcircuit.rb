require "formula"

class Xcircuit < Formula
  homepage "http://opencircuitdesign.com/xcircuit/"
  url "http://opencircuitdesign.com/xcircuit/archive/xcircuit-3.7.57.tgz"
  sha1 "29cdb84fb6083c27398a351e0481b310c4f8d44c"

  depends_on "homebrew/dupes/tcl-tk" => "with-x11"
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-tcl=#{Formula["tcl-tk"].opt_prefix}",
                          "--with-tk=#{Formula["tcl-tk"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/xcircuit", "--version"
  end
end
