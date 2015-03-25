class Cdb < Formula
  homepage "http://cr.yp.to/cdb.html"
  url "http://cr.yp.to/cdb/cdb-0.75.tar.gz"
  sha256 "1919577799a50c080a8a05a1cbfa5fa7e7abc823d8d7df2eeb181e624b7952c5"

  def install
    inreplace "conf-home", "/usr/local", prefix
    system "make", "setup"
  end

  test do
    record = "+4,8:test->homebrew\n\n"
    pipe_output("#{bin}/cdbmake db dbtmp", record, 0)
    assert File.exist? "db"
    assert_equal(record,
                 pipe_output("#{bin}/cdbdump", (testpath/"db").binread, 0))
  end
end
