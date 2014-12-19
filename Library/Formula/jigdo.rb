class Jigdo < Formula
  homepage "http://atterer.org/jigdo/"
  url "http://atterer.org/sites/atterer/files/2009-08/jigdo/jigdo-0.7.3.tar.bz2"
  sha1 "7b83c35af71f908b31b9aa55b0dda9dfb4d224f0"
  revision 1

  bottle do
    sha1 "082410ddb96160d7dad904396e54c628e395efd6" => :yosemite
    sha1 "3728075c968660a34393a2c8657d2e3f18fb0017" => :mavericks
    sha1 "f059fdafb3d3891c27e86ef0d31ef20d14bf7c2c" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "wget" => :recommended
  depends_on "berkeley-db4"
  depends_on "gtk+"

  # Use MacPorts patch for compilation on 10.9; this software is no longer developed.
  patch :p0 do
    url "http://trac.macports.org/export/113020/trunk/dports/net/jigdo/files/patch-src-compat.hh.diff"
    sha1 "3318ecbe8b2bb20e8e36c70dc10ff366df2009f3"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jigdo-file", "-h"
  end
end
