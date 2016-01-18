class Cln < Formula
  desc "Class Library for Numbers"
  homepage "http://www.ginac.de/CLN/"
  url "http://www.ginac.de/CLN/cln-1.3.4.tar.bz2"
  sha256 "2d99d7c433fb60db1e28299298a98354339bdc120d31bb9a862cafc5210ab748"

  bottle do
    cellar :any
    revision 1
    sha256 "b816f165673f58fb952669c7fa542b2fe52257e6572853785efee0048ea35d6a" => :el_capitan
    sha256 "95e74408a4b9dca4e7a939d2ff79e9ab16f3193622027d3d741eb6fc9cc7695d" => :yosemite
    sha256 "048947d9343c8848897be272cae74d98cd869fa3d64fa6f2bfe82cb68ca100b9" => :mavericks
  end

  option "without-test", "Skip compile-time checks (Not recommended)"

  deprecated_option "without-check" => "without-test"

  depends_on "gmp"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    assert_match "3.14159", shell_output("#{bin}/pi 6")
  end
end
