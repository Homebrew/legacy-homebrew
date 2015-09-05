class BerkeleyDb < Formula
  desc "High performance key/value database"
  homepage "https://www.oracle.com/technology/products/berkeley-db/index.html"
  url "http://download.oracle.com/berkeley-db/db-6.1.26.tar.gz"
  sha256 "dd1417af5443f326ee3998e40986c3c60e2a7cfb5bfa25177ef7cadb2afb13a6"

  bottle do
    cellar :any
    sha256 "3e4324500931e32e3a187f9790b4465efd4d249dc9ec03ff46b4209ed061e935" => :yosemite
    sha256 "b2ba3aff83ee27a52115f47abc3c1767d124841ad342e63e433dfa36af064b36" => :mavericks
    sha256 "8f5a87bc3336e01f8528ae8aaae24c83e8fa10e8f01ee65e8cac4af7d0786bf1" => :mountain_lion
  end

  option "with-java", "Compile with Java support."
  option "with-sql", "Compile with SQL support."

  deprecated_option "enable-sql" => "with-sql"

  def install
    # BerkeleyDB dislikes parallel builds
    ENV.deparallelize
    # --enable-compat185 is necessary because our build shadows
    # the system berkeley db 1.x
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-cxx
      --enable-compat185
    ]
    args << "--enable-java" if build.with? "java"
    args << "--enable-sql" if build.with? "sql"

    # BerkeleyDB requires you to build everything from the build_unix subdirectory
    cd "build_unix" do
      system "../dist/configure", *args
      system "make", "install"

      # use the standard docs location
      doc.parent.mkpath
      mv prefix/"docs", doc
    end
  end
end
