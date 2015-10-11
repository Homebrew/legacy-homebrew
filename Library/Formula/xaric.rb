class Xaric < Formula
  desc "IRC client"
  homepage "http://xaric.org/"
  url "http://xaric.org/software/xaric/releases/xaric-0.13.6.tar.gz"
  sha256 "dbed41ed43efcea05baac0af0fe87cca36eebd96e5b7d4838b38cca3da4518bb"
  revision 1

  bottle do
    revision 1
    sha256 "cf732bf5a8c56555687ac99752f06e7ad2cdf5948943c3edaf9d758c0b713d33" => :el_capitan
    sha256 "bc164f72419c5185fde2a73f75ea48724f0c5ccccf892241001e9df3cae4b86b" => :yosemite
    sha256 "f999829820363af7324ed2934f1447ef2fb068ec9935be41687e2249d7fca328" => :mavericks
  end

  depends_on "openssl"

  def install
    # Re OpenSSL: https://github.com/laeos/xaric/issues/2
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "withval=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match(/Xaric #{version}/, shell_output("script -q /dev/null xaric -v"))
  end
end
