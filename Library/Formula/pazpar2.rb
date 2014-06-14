require "formula"

class Pazpar2 < Formula
  homepage "http://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.6.43.tar.gz"
  sha1 "470cddff6670dc24ed144cf503beb3ef054c6392"

  bottle do
    cellar :any
    sha1 "4f808f4797b985d157f5a3e470162d311a49a3b2" => :mavericks
    sha1 "c63d1ac14505b3e747cb3ec057b0c5a7f8a10188" => :mountain_lion
    sha1 "861e672d1dd5a201ffa83a6b1ebedec079de3590" => :lion
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
