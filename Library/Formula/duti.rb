require "formula"

class Duti < Formula
  homepage "http://duti.org/"
  head "https://github.com/moretension/duti.git"
  url "https://github.com/moretension/duti/archive/duti-1.5.3.tar.gz"
  sha1 "2a4e34002db33133feb8057968d1f670bf422ea5"

  bottle do
    cellar :any
    sha1 "46a7a0eb73e8eb4daf5eeed21dc766d61e9f7992" => :yosemite
    sha1 "03f60c65c60faf518582574e43f51710144dffe5" => :mavericks
    sha1 "3c6cd123eb6c1250048150417ae3f7cc2737b36f" => :mountain_lion
  end

  depends_on "autoconf" => :build

  def install
    system "autoreconf", "-vfi"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/duti", "-x", "txt"
  end
end
