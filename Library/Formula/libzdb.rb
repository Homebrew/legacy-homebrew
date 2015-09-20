class Libzdb < Formula
  desc "Database connection pool library"
  homepage "http://tildeslash.com/libzdb/"
  url "http://tildeslash.com/libzdb/dist/libzdb-3.1.tar.gz"
  sha256 "0f01abb1b01d1a1f4ab9b55ad3ba445d203fc3b4757abdf53e1d85e2b7b42695"

  bottle do
    cellar :any
    revision 1
    sha1 "e733947b31862fd1c8964872a29bd8aa5479635c" => :yosemite
    sha1 "aa3ccc94e86d2158c1041474c79cdccb25e5d0b1" => :mavericks
    sha1 "4ab2279dae830f543cc9fec5d41197150163bf83" => :mountain_lion
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
