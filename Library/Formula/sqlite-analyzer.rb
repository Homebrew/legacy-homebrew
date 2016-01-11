class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2015/sqlite-src-3080803.zip"
  version "3.8.8.3"
  sha256 "790ff6be164488d176b3bed7e0e0850bac1567a4011381307685d48eb69fab48"

  bottle do
    cellar :any
    sha256 "9eb7d3df9680d81826da6e39041d28abeba247cbb084a8690524485d34a934c7" => :yosemite
    sha256 "5092ae2ccce00d9dbf4b8d33a318883054eafd904d55e0ba8ef6a415f7b31497" => :mavericks
    sha256 "abaf9bc21f00454ee737716345f633383beb92bda83f45c27420eebab3d4d5b7" => :mountain_lion
  end

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
