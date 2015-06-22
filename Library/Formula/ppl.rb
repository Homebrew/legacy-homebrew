class Ppl < Formula
  desc "Parma Polyhedra Library"
  homepage "http://bugseng.com/products/ppl"
  url "ftp://ftp.cs.unipr.it/pub/ppl/releases/1.1/ppl-1.1.tar.xz"
  version "1.1"
  sha256 "c48ccd74664ec2cd3cdb5e37f287974ccb062f0384dc658d4053c424b19ad178"

  depends_on "gmp"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def uninstall
    system "make", "uninstall"
  end

  test do
    system "make", "check"
  end
end
