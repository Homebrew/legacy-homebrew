require "formula"

class Pgformatter < Formula
  homepage "http://sqlformat.darold.net/"
  url "https://downloads.sourceforge.net/project/pgformatter/1.2/pgFormatter-1.2.tar.gz"
  sha1 "598c39fa7f3f511aa376e7a18457139a9393fe74"

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
