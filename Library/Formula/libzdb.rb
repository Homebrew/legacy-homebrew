class Libzdb < Formula
  desc "Database connection pool library"
  homepage "http://tildeslash.com/libzdb/"
  url "http://tildeslash.com/libzdb/dist/libzdb-3.1.tar.gz"
  sha256 "0f01abb1b01d1a1f4ab9b55ad3ba445d203fc3b4757abdf53e1d85e2b7b42695"
  revision 1

  bottle do
    cellar :any
    sha256 "05236a5fa351eab9946a17e8c3219277a553287d40686e9dd3034acb02faed8a" => :el_capitan
    sha256 "bcee0be3f6bb6eab4d8213f239db7f8d86b8548f99504be4b8a5b735c9f66bf4" => :yosemite
    sha256 "989e41024a32bfab580881d647c8d7dbad9d9bb17a3fd9072e784ff98e2d0cef" => :mavericks
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
