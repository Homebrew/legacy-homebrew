require "formula"

class Pazpar2 < Formula
  homepage "http://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.6.39.tar.gz"
  sha1 "2be29efecc4f0ed5a6a300638b7ef6577d1e34e4"

  bottle do
    cellar :any
    sha1 "c8195a3a96b9278abdc8afba4873715a342455c6" => :mavericks
    sha1 "de02d686252da5279a58ac85f5d09d9398dbebd2" => :mountain_lion
    sha1 "e221b78ef5cb0759c4eeb86f1c3bc8a13ad8e44f" => :lion
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
