class Bashdb < Formula
  desc "Bash shell debugger"
  homepage "http://bashdb.sourceforge.net"
  url "https://downloads.sourceforge.net/project/bashdb/bashdb/4.3-0.91/bashdb-4.3-0.91.tar.bz2"
  version "4.3-0.91"
  sha256 "60117745813f29070a034c590c9d70153cc47f47024ae54bfecdc8cd86d9e3ea"

  bottle do
    cellar :any_skip_relocation
    sha256 "acaeaec58a610b8ee53f3ef1ebbee800991b1790a50bf38f6496e4c3e07a8a40" => :el_capitan
    sha256 "407d84f8f4e34a1f9accaf6a5cb74c50028b97009842c592b969020e5a04630e" => :yosemite
    sha256 "f715486224a5d5625b9cc5645235e7f977fce749254dbde3254028b2700d8860" => :mavericks
  end

  depends_on "bash"
  depends_on :macos => :mountain_lion

  def install
    system "./configure", "--with-bash=#{HOMEBREW_PREFIX}/bin/bash",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system "#{bin}/bashdb", "--version"
  end
end
