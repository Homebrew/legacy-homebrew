class Xaric < Formula
  desc "IRC client"
  homepage "http://xaric.org/"
  url "http://xaric.org/software/xaric/releases/xaric-0.13.6.tar.gz"
  sha256 "dbed41ed43efcea05baac0af0fe87cca36eebd96e5b7d4838b38cca3da4518bb"
  revision 1

  bottle do
    sha256 "9fa48c2e441b64c3ad5a40df0fe6713620d8cda8f8cecbe91af971cdaa4f4954" => :yosemite
    sha256 "964f0da5518e9da5c1a2b712df4757864e8d4d4be9139ac0fa1b59fd1f38f82c" => :mavericks
    sha256 "76c6b01fd4c5b9151eeef849755c2c47eb63b02dfa979bdba7d8e75d17e1f500" => :mountain_lion
  end

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
