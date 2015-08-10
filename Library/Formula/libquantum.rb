class Libquantum < Formula
  desc "C library for the simulation of quantum mechanics"
  homepage "http://www.libquantum.de/"
  url "http://www.libquantum.de/files/libquantum-1.0.0.tar.gz"
  sha256 "b0f1a5ec9768457ac9835bd52c3017d279ac99cc0dffe6ce2adf8ac762997b2c"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    system "make", "quobtools_install"
  end

  test do
    # No test
    system "true"
  end
end
