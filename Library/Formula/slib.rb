class Slib < Formula
  homepage "http://people.csail.mit.edu/jaffer/SLIB"
  url "http://groups.csail.mit.edu/mac/ftpdir/scm/slib-3b4.zip"
  version "3b4"
  sha1 "dda1ed78ff7164738a1a8c51f1f7c08ec1db79eb"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "infoz", "INSTALL_INFO=install-info"
    system "make", "install", "INSTALL_INFO=install-info"
  end

  test do
    system "#{bin}/slib", "-v"
  end
end
