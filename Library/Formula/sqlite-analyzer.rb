class SqliteAnalyzer < Formula
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2015/sqlite-src-3080803.zip"
  version "3.8.8.3"
  sha256 "790ff6be164488d176b3bed7e0e0850bac1567a4011381307685d48eb69fab48"

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "sqlite3_analyzer"
    bin.install "sqlite3_analyzer"
  end

  test do
    dbpath = testpath/"school.sqlite"
    sqlpath = testpath/"school.sql"
    sqlpath.write <<-EOS.undent
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    EOS
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    system "#{bin}/sqlite3_analyzer", dbpath
  end
end
