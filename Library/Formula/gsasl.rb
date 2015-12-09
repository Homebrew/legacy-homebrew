class Gsasl < Formula
  desc "SASL library command-line interface"
  homepage "https://www.gnu.org/software/gsasl/"
  url "http://ftpmirror.gnu.org/gsasl/gsasl-1.8.0.tar.gz"
  mirror "https://ftp.gnu.org/gsasl/gsasl-1.8.0.tar.gz"
  sha256 "310262d1ded082d1ceefc52d6dad265c1decae8d84e12b5947d9b1dd193191e5"

  depends_on "libntlm" => :optional

  bottle do
    cellar :any
    revision 2
    sha256 "8dbca0c2938ab3b5077fe7ed572437a0f724e479a7f102d9c40f959b1483f09d" => :el_capitan
    sha256 "afc44c1161ffa2ae09bee4a82c25e626562d950ae092356fba204789e4b4752e" => :yosemite
    sha256 "df498ac7247b3f54bdc9720249fa4a1cee72bf8c5011d06889d8ecdebaff1aaa" => :mavericks
    sha256 "5585b8bddf849b2b4b3f67da253c97556bfa526b8345006595cdefddf3385dd5" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--with-gssapi-impl=mit",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/gsasl")
  end
end
