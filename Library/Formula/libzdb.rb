require 'formula'

class Libzdb < Formula
  homepage 'http://tildeslash.com/libzdb/'
  url 'http://tildeslash.com/libzdb/dist/libzdb-2.10.5.tar.gz'
  sha1 '30f975e73caf58f1fa02260ed7136185a3ba2d27'

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
