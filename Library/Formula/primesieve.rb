class Primesieve < Formula
  desc "Optimized sieve of Eratosthenes implementation"
  homepage "http://primesieve.org/"
  url "https://dl.bintray.com/kimwalisch/primesieve/primesieve-5.4.2.tar.gz"
  sha256 "73abf4ff118e8d41ffaf687cf902b0b53a8bbc357bf4efa1798477d346f85cc8"

  bottle do
    cellar :any
    sha256 "db994cff1eea28e828e3c0df8d1a4bc82be16ff377ab7088224f9afdb609978d" => :yosemite
    sha256 "48e0da06374d96fc4e5ded73c5093b947a9dd254fb257cf14405c27a076fa77e" => :mavericks
    sha256 "1fd0410a04f8cc14b90577d714223517712bde14aaefbd1250787c41a3065e23" => :mountain_lion
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
