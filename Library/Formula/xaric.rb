class Xaric < Formula
  homepage "http://xaric.org/"
  url "http://xaric.org/software/xaric/releases/xaric-0.13.6.tar.gz"
  sha256 "dbed41ed43efcea05baac0af0fe87cca36eebd96e5b7d4838b38cca3da4518bb"
  revision 1

  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match(/Xaric #{version}/,
                 shell_output("script -q /dev/null xaric -v"))
  end
end
