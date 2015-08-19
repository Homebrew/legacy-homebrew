class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "http://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.11.3.tar.gz"
  sha256 "bee8d3529a129cda7c5281b7e9b50ca5d9a2ed1647f4e7cae7da6b568c00eb7a"

  bottle do
    cellar :any
    sha256 "bde377a7f03ccb193a462d947982891a6270895cd629fc7503ef29ad52a5424a" => :yosemite
    sha256 "f615f07179329182d2f00344c9b4a7d65b07692b45ba292dc035f503123755c1" => :mavericks
    sha256 "87127b01639c7ea919f7570e6cc041b11621b7e78fc43fdfce8881f72ad6e0a6" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c" => :recommended
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
