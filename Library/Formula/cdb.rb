class Cdb < Formula
  desc "Create and read constant databases"
  homepage "http://cr.yp.to/cdb.html"
  url "http://cr.yp.to/cdb/cdb-0.75.tar.gz"
  sha256 "1919577799a50c080a8a05a1cbfa5fa7e7abc823d8d7df2eeb181e624b7952c5"

  bottle do
    cellar :any
    sha256 "1e10737fdb2b905ca823a5304a1570906f262c3e4d9b4f6fa35f3d24ad084001" => :yosemite
    sha256 "b99e71ef152cfc4744face7938bea54a1da6ca0b51b9e53c708b0472b1485e9c" => :mavericks
    sha256 "700350e94a89862ea16075d66f8529ee58ba97b3ead1f2419992f6a3024b40f8" => :mountain_lion
  end

  def install
    inreplace "conf-home", "/usr/local", prefix
    system "make", "setup"
  end

  test do
    record = "+4,8:test->homebrew\n\n"
    pipe_output("#{bin}/cdbmake db dbtmp", record, 0)
    assert File.exist? "db"
    assert_equal(record,
                 pipe_output("#{bin}/cdbdump", (testpath/"db").binread, 0),
                )
  end
end
