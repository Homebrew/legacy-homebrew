require 'formula'

class Libzdb < Formula
  homepage 'http://tildeslash.com/libzdb/'
  url 'http://tildeslash.com/libzdb/dist/libzdb-2.10.6.tar.gz'
  sha1 'ae649655788a8db50f2bb0c36f90afe8a7fcc40b'

  option 'without-sqlite',     "Compile without SQLite support"
  option 'without-postgresql', "Compile without PostgreSQL support"
  option 'without-mysql',      "Compile without MySQL support"

  depends_on :postgresql unless build.include? 'without-postgresql'
  depends_on :mysql unless build.include? 'without-mysql'
  depends_on 'sqlite' unless build.include? 'without-sqlite'

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}"]

    args << "--without-sqlite"     if build.include? 'without-sqlite'
    args << "--without-mysql"      if build.include? 'without-mysql'
    args << "--without-postgresql" if build.include? 'without-postgresql'

    system "./configure", *args
    system "make install"
  end
end
