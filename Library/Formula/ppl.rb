class Ppl < Formula
  desc "Parma Polyhedra Library; GPL licensed"
  homepage "http://bugseng.com/products/ppl"
  url "http://bugseng.com/products/ppl/download/ftp/releases/1.1/ppl-1.1.tar.xz"
  sha256 "c48ccd74664ec2cd3cdb5e37f287974ccb062f0384dc658d4053c424b19ad178"

  depends_on "gmp"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
