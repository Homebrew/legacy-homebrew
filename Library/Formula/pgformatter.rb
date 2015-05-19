require "formula"

class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "http://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v1.4.tar.gz"
  sha1 "bdbeefd9b3d8088a69816d3f578453c4a886feae"

  def install
    system "perl", "Makefile.PL", "DESTDIR=."
    system "make", "install"
    bin.install "blib/script/pg_format"
    man1.install "blib/man1/pg_format.1"
  end

  test do
    test_file = (testpath/'test.sql')
    test_file.write('SELECT * FROM foo')
    system "#{bin}/pg_format", test_file
  end
end
