class Bmon < Formula
  desc "Interface bandwidth monitor"
  homepage "https://github.com/tgraf/bmon"
  url "https://github.com/tgraf/bmon/releases/download/v3.8/bmon-3.8.tar.gz"
  sha256 "da3e9f5f82f6e65bf08d912cc1e6ba450e488c543151f4b37791da03373054ff"

  bottle do
    sha256 "576b5d70844675bcf7dfa15df9e7b69065e2c951dbb52e1b156215e8a8ddd93c" => :yosemite
    sha256 "1f170230b89afb2a9761cb30283a7cfdc18468e6df7e4744fc882d60bb67852d" => :mavericks
    sha256 "84e9754b63dd5133669d7194ceab9ae36b90f4af5e05f77a9f1ed9e744121802" => :mountain_lion
  end

  head do
    url "https://github.com/tgraf/bmon.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "confuse" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/bmon", "-o", "ascii:quitafter=1"
  end
end
