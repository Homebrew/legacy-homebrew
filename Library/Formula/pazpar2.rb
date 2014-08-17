require "formula"

class Pazpar2 < Formula
  homepage "http://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.7.1.tar.gz"
  sha1 "92917fbabf5d6d0180547fe4dfdeae9c10b13e19"

  bottle do
    cellar :any
    sha1 "ba3d4d4ad5cea431ec0dcee80b9eff551b609d0c" => :mavericks
    sha1 "d2049205664630013f9ff05e1ec50d3156d7259a" => :mountain_lion
    sha1 "285021269426bdd196d2cbe7090fe1ce2f3680fe" => :lion
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
