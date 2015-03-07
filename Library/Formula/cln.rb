require "formula"

class Cln < Formula
  homepage "http://www.ginac.de/CLN/"
  url "http://www.ginac.de/CLN/cln-1.3.4.tar.bz2"
  sha1 "76f73071236ead72ba5c9ee892f29ca24e557b8c"

  bottle do
    cellar :any
    sha1 "4e7caf04c3fc9e5b38bc45b2ca8110aefdffea28" => :yosemite
    sha1 "32c6b097023b1c7e5f7bea248a39648356dc02e3" => :mavericks
    sha1 "1c2e8079757a031feb65279be81f0b9874098134" => :mountain_lion
  end

  depends_on "gmp"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make install"
  end
end
