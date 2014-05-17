require "formula"

class Pazpar2 < Formula
  homepage "http://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.6.41.tar.gz"
  sha1 "89c97f35b7aac0e88798458192132e1cd8f2af6f"

  bottle do
    cellar :any
    sha1 "491cc42e1f70344396f73270bba9101c487cdfc1" => :mavericks
    sha1 "45501784c3d44ebdc833047573d8e78c2e495a39" => :mountain_lion
    sha1 "29aa33b793d41ac2285220a85d252958939a109e" => :lion
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
