class Cln < Formula
  desc "CLN: Class Library for Numbers"
  homepage "http://www.ginac.de/CLN/"
  url "http://www.ginac.de/CLN/cln-1.3.4.tar.bz2"
  sha256 "2d99d7c433fb60db1e28299298a98354339bdc120d31bb9a862cafc5210ab748"

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
    system "make", "install"
  end
end
