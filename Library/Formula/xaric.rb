class Xaric < Formula
  desc "IRC client"
  homepage "http://xaric.org/"
  url "http://xaric.org/software/xaric/releases/xaric-0.13.7.tar.gz"
  sha256 "fd8cd677e2403e44ff525eac7c239cd8d64b7448aaf56a1272d1b0c53df1140c"

  bottle do
    revision 1
    sha256 "cf732bf5a8c56555687ac99752f06e7ad2cdf5948943c3edaf9d758c0b713d33" => :el_capitan
    sha256 "bc164f72419c5185fde2a73f75ea48724f0c5ccccf892241001e9df3cae4b86b" => :yosemite
    sha256 "f999829820363af7324ed2934f1447ef2fb068ec9935be41687e2249d7fca328" => :mavericks
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
