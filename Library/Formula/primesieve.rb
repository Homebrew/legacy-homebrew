class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "http://primesieve.org/"
  url "https://dl.bintray.com/kimwalisch/primesieve/primesieve-5.5.0.tar.gz"
  sha256 "f0f818902967ce7c911c330c578a52ec62dbbd9b12a68b8d3a3bc79b601e52b0"

  bottle do
    cellar :any
    sha256 "106a0dcebe252a20d211014b5059456cb480a2ea62b53e07fcac2777156d2be2" => :el_capitan
    sha256 "670f49877fa80e647e5a62a827e1df12618b62c8df7b4a09f7957f92ca9ef3bc" => :yosemite
    sha256 "2497d368a7ee2601ea83dba4c513ae55cc05864f1bf5974a6ba7d6f9d1cf15cf" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-silent-rules",
           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/primesieve", "2", "1000", "--count=1", "-p2"
  end
end
