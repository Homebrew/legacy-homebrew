class LibodbSqlite < Formula
  homepage "http://www.codesynthesis.com/products/odb/"
  url "http://www.codesynthesis.com/download/odb/2.4/libodb-sqlite-2.4.0.tar.gz"
  sha256 "cd687c882a8dc14ded4eb160e82de57e476b1feef5c559c5a6a5c7e671a10cf4"

  depends_on "libodb" => :recommended
  option "without-libodb", "Don't install libodb"

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
