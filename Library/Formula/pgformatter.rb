class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "http://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v1.4.tar.gz"
  sha256 "d8bb04f1f0d35cbae9aeb8ae91273f3d13ce07305226605c1b2db161010bedc9"

  def install
    system "perl", "Makefile.PL", "DESTDIR=."
    system "make", "install"
    bin.install "blib/script/pg_format"
    man1.install "blib/man1/pg_format.1"
  end

  test do
    test_file = (testpath/"test.sql")
    test_file.write("SELECT * FROM foo")
    system "#{bin}/pg_format", test_file
  end
end
