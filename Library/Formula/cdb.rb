class Cdb < Formula
  desc "Create and read constant databases"
  homepage "https://cr.yp.to/cdb.html"
  url "https://cr.yp.to/cdb/cdb-0.75.tar.gz"
  sha256 "1919577799a50c080a8a05a1cbfa5fa7e7abc823d8d7df2eeb181e624b7952c5"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "48bbaace024d61f6e464c0251cebaae18aaea57f8874ec0e4df41dd15ab81cf4" => :el_capitan
    sha256 "d37679fe36ab396b9b195ee65da4271320f56afba844cf9167f5b50b0bb1ee11" => :yosemite
    sha256 "8d79537ee9db01074b1766082626913dee4e1b01b1de1b11975f57e64ca1b0bd" => :mavericks
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
