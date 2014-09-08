require "formula"

class Pazpar2 < Formula
  homepage "http://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.7.4.tar.gz"
  sha1 "65950de34c3e0e11c928db37f0a18912b7670660"

  bottle do
    cellar :any
    sha1 "d012c3ac4395e51b93579e49e7e4e40f534279c2" => :mavericks
    sha1 "3b08ae65de7321bd6a4d9d72d0baa436b332e023" => :mountain_lion
    sha1 "d9c26822fa3fa8cf26e9374d8e26d1f9e4b4b689" => :lion
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
