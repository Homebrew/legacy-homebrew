class Xaric < Formula
  desc "IRC client"
  homepage "https://xaric.org/"
  url "https://xaric.org/software/xaric/releases/xaric-0.13.7.tar.gz"
  sha256 "fd8cd677e2403e44ff525eac7c239cd8d64b7448aaf56a1272d1b0c53df1140c"

  bottle do
    sha256 "6605f6b79fb540c515f05bce2c222f10487cf5789c22450456998c4d71e1a52c" => :el_capitan
    sha256 "be969c46a98cd5a89f26ab589f65a9b86bab2d491ce1feee0902b92c0a5b56d7" => :yosemite
    sha256 "d445890b697137ebc45b8218bf5a839e386c511b12e7a9cf7986af29dd76e23a" => :mavericks
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match(/Xaric #{version}/, shell_output("script -q /dev/null xaric -v"))
  end
end
