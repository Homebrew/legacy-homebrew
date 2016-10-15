class Libodb < Formula
  homepage "http://www.codesynthesis.com/products/odb/"
  url "http://www.codesynthesis.com/download/odb/2.4/libodb-2.4.0.tar.gz"
  sha256 "bfb9c398a6fdec675e33b320a1f80bdf74d8fbb700073bf17062f5b3ae1a2d5c"

  depends_on "odb" => :optional
  option "with-odb", "Install the ODB compiler"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "CC=clang", "CXX=clang++ -stdlib=libstdc++",
                          "LDFLAGS=-L/usr/lib",
                          "LIBS=-lstdc++"
    system "make", "install"

    opoo "libodb-* packages must be build with the same compiler your app is.\
      This package assumes your app is built with \"clang\".".undent
  end

  test do
    system "true"
  end
end
