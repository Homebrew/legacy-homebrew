class Hebcal < Formula
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v3.17.tar.gz"
  sha1 "03549601660bb20cc8e0a1e03664ef4f1b2549d0"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    system "hebcal"
  end
end
