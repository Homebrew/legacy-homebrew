class Jigdo < Formula
  desc "Tool to distribute very large files over the internet"
  homepage "http://atterer.org/jigdo/"
  url "http://atterer.org/sites/atterer/files/2009-08/jigdo/jigdo-0.7.3.tar.bz2"
  sha256 "875c069abad67ce67d032a9479228acdb37c8162236c0e768369505f264827f0"
  revision 2

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
    url "https://trac.macports.org/export/113020/trunk/dports/net/jigdo/files/patch-src-compat.hh.diff"
    sha256 "a21aa8bcc5a03a6daf47e0ab4e04f16e611e787a7ada7a6a87c8def738585646"
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
