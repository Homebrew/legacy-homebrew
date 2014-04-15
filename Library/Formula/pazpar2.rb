require "formula"

class Pazpar2 < Formula
  homepage "http://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.6.40.tar.gz"
  sha1 "db2720925cc429fd4158a31ff8927ba458fd2f12"

  bottle do
    cellar :any
    sha1 "fbcfb7c70a22494468f622e1aa1bb45080558cf9" => :mavericks
    sha1 "1f7af0f4936fedca7400f36d6223bea69fa96d7d" => :mountain_lion
    sha1 "2f2489c4108c984420f2a7744d170a7c652dd0b9" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "yaz"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test-config.xml").write <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <pazpar2 xmlns="http://www.indexdata.com/pazpar2/1.0">
      <threads number="2"/>
      <server>
        <listen port="8004"/>
      </server>
    </pazpar2>
    EOS

    system "#{sbin}/pazpar2", "-t", "-f", "#{testpath}/test-config.xml"
  end
end
