class SqliteAnalyzer < Formula
  homepage "http://www.sqlite.org/"
  url "http://www.sqlite.org/2015/sqlite-src-3080803.zip"
  version "3.8.8.3"
  sha256 "790ff6be164488d176b3bed7e0e0850bac1567a4011381307685d48eb69fab48"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "sqlite3_analyzer"
    bin.install "sqlite3_analyzer"
  end

  test do
    out = `#{bin}/sqlite3_analyzer 2>&1`
    assert_match "Usage", out, "Not printing usage"
    assert_equal 1, $?.exitstatus
  end
end
