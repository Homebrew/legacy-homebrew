class Opendbx < Formula
  desc "Lightweight but extensible database access library in C"
  homepage "http://www.linuxnetworks.de/doc/index.php/OpenDBX"
  url "http://linuxnetworks.de/opendbx/download/opendbx-1.4.6.tar.gz"
  sha256 "2246a03812c7d90f10194ad01c2213a7646e383000a800277c6fb8d2bf81497c"

  depends_on "sqlite"

  def install
    # Reported upstream: http://bugs.linuxnetworks.de/index.php?do=details&id=40
    inreplace "utils/Makefile.in", "$(LIBSUFFIX)", ".dylib"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-backends=sqlite3"
    system "make"
    system "make", "install"
  end

  test do
    testfile = testpath/"test.sql"
    testfile.write <<-EOS.undent
      create table t(x);
      insert into t values("Hello");
      .header
      select * from t;
      .quit
    EOS

    assert_match /"Hello"/,
      shell_output("#{bin}/odbx-sql odbx-sql -h ./ -d test.sqlite3 -b sqlite3 < #{testpath}/test.sql")
  end
end
