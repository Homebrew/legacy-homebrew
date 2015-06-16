class Opendbx < Formula
  desc "Lightweight but extensible database access library in C"
  homepage "http://www.linuxnetworks.de/doc/index.php/OpenDBX"
  url "http://linuxnetworks.de/opendbx/download/opendbx-1.4.6.tar.gz"
  sha256 "2246a03812c7d90f10194ad01c2213a7646e383000a800277c6fb8d2bf81497c"

  bottle do
    sha256 "d107e7392614948e26b5720072bddb06b07c9f9e07a3804ccdd9c91beecfcc77" => :yosemite
    sha256 "8d08b6f6a5164c357cfb61fe288f2d129e7452c1e7f58efb0ef228e6ba747887" => :mavericks
    sha256 "2ea5595a73cc1317ab7d760e75cb428d3c5440c490a0ba4b001b8a6e84ce785c" => :mountain_lion
  end

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
