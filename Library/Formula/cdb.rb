class Cdb < Formula
  desc "Create and read constant databases"
  homepage "https://cr.yp.to/cdb.html"
  url "https://cr.yp.to/cdb/cdb-0.75.tar.gz"
  sha256 "1919577799a50c080a8a05a1cbfa5fa7e7abc823d8d7df2eeb181e624b7952c5"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "ac5a34c222875d86113275127632fe02ccc15c0332c7719cdac8321aa0f83bc4" => :el_capitan
    sha256 "4181f08e221e9cebd1cb9f7dd0082fef86d8f8571831491464340b68be238186" => :yosemite
    sha256 "e0be7db3074bc27f430c2b7536b4f3676cafc9d7e574971cdb592340be0fec06" => :mavericks
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
                 pipe_output("#{bin}/cdbdump", (testpath/"db").binread, 0))
  end
end
