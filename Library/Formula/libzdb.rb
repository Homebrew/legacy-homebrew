require 'formula'

class Libzdb < Formula
  homepage 'http://tildeslash.com/libzdb/'
  url 'http://tildeslash.com/libzdb/dist/libzdb-2.11.1.tar.gz'
  sha1 'c6fd44a779e7e0c112ebd7b30a1ee08f86feb41e'

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
