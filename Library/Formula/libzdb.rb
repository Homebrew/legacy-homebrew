class Libzdb < Formula
  desc "Database connection pool library"
  homepage "http://tildeslash.com/libzdb/"
  url "http://tildeslash.com/libzdb/dist/libzdb-3.0.tar.gz"
  sha256 "e334bcb9ca1410e863634a164e3b1b5784018eb6e90b6c2b527780fc29a123c8"

  bottle do
    cellar :any
    revision 1
    sha1 "e733947b31862fd1c8964872a29bd8aa5479635c" => :yosemite
    sha1 "aa3ccc94e86d2158c1041474c79cdccb25e5d0b1" => :mavericks
    sha1 "4ab2279dae830f543cc9fec5d41197150163bf83" => :mountain_lion
  end

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
