class Rgxg < Formula
  desc "C library and command-line tool to generate (extended) regular expressions"
  homepage "http://rgxg.sourceforge.net"
  url "https://downloads.sourceforge.net/project/rgxg/rgxg/rgxg-0.1.tar.gz"
  sha256 "4adbc128faf87e44ec80d9dfd3b34871c84634c2ae0f9cfaedd16b07d13f9484"

  bottle do
    cellar :any
    sha256 "7d04b00b4cc0b150d5e5ecb987eca5b97df0eefb8421dc9c43dbb4b6afe3f79f" => :el_capitan
    sha256 "5a092ea507a438e7f28b213a5011bdb8621c3f52424be8bb0a98a6697d32cd68" => :yosemite
    sha256 "7f1ad5b5b78eab2fc87474cbd7e3008a245579a58f0c526d488c4690a29154f7" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rgxg", "range", "1", "10"
  end
end
