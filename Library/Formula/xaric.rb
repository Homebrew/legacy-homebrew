class Xaric < Formula
  desc "IRC client"
  homepage "https://xaric.org/"
  url "https://xaric.org/software/xaric/releases/xaric-0.13.7.tar.gz"
  sha256 "fd8cd677e2403e44ff525eac7c239cd8d64b7448aaf56a1272d1b0c53df1140c"

  bottle do
    revision 1
    sha256 "9ddfb8878904f92a7281f5611a11b72b81ebed0ef6ac7af9c10588cb717b9317" => :el_capitan
    sha256 "f29d234ec8065f976ce8f14e21374871e5b8b2d092a26ad163d9cac32988bb9b" => :yosemite
    sha256 "3b8f2a6b837e43ff57ef626b4d46142562c1eda120ac5889124eab11d8b46b86" => :mavericks
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
