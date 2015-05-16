class Pkgdiff < Formula
  homepage "https://lvc.github.io/pkgdiff/"
  url "https://github.com/lvc/pkgdiff/archive/1.6.3.tar.gz"
  sha256 "80d5bdec415db2627c3da2f086a4172791a667a0bbb33743a0c84a49b8ce3332"

  depends_on "wdiff"
  depends_on "gawk"
  depends_on "binutils" => :recommended
  depends_on "rpm" => :optional
  depends_on "dpkg" => :optional

  def install
    system "perl", "Makefile.pl", "--install", "--prefix=#{prefix}"
  end

  test do
    system "pkgdiff"
  end
end
