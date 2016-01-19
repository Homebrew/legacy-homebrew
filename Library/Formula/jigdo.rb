class Jigdo < Formula
  desc "Tool to distribute very large files over the internet"
  homepage "http://atterer.org/jigdo/"
  url "http://atterer.org/sites/atterer/files/2009-08/jigdo/jigdo-0.7.3.tar.bz2"
  sha256 "875c069abad67ce67d032a9479228acdb37c8162236c0e768369505f264827f0"
  revision 2

  bottle do
    revision 2
    sha256 "8128ebe3947194e46c94ee9f141c1000ce0a8a0281522a4a858e341bae011bf9" => :el_capitan
    sha256 "1a8a7505c33fc6ee08c23effc8776b4a575947fab9b8e1ea08c03df0c1d83d65" => :yosemite
    sha256 "78483d046c8deea235b333401dc959d7e928dc65728519a789ba09488546cced" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "wget" => :recommended
  depends_on "berkeley-db"
  depends_on "gtk+"

  # Use MacPorts patch for compilation on 10.9; this software is no longer developed.
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/e101570/jigdo/patch-src-compat.hh.diff"
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
    assert_match "version #{version}", shell_output("#{bin}/jigdo-file -v")
  end
end
