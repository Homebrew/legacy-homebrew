class Libzdb < Formula
  desc "Database connection pool library"
  homepage "http://tildeslash.com/libzdb/"
  url "http://tildeslash.com/libzdb/dist/libzdb-3.1.tar.gz"
  sha256 "0f01abb1b01d1a1f4ab9b55ad3ba445d203fc3b4757abdf53e1d85e2b7b42695"

  bottle do
    cellar :any
    sha256 "48cc40f4078e7867958494efd94432349d4b677f37194143f87f9009808edbdb" => :el_capitan
    sha256 "0266f72e8761f25d4b35e0c73c3ecb8cff9f90ad6aa43e1f63185cb63b51129c" => :yosemite
    sha256 "7f362b60f5920bf0724507445d29479aa4045d1306634083e6b1e2f39619d6fa" => :mavericks
  end

  depends_on "openssl"
  depends_on :postgresql => :recommended
  depends_on :mysql => :recommended
  depends_on "sqlite" => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--without-postgresql" if build.without? "postgresql"
    args << "--without-mysql" if build.without? "mysql"
    args << "--without-sqlite" if build.without? "sqlite"

    system "./configure", *args
    system "make", "install"
  end
end
