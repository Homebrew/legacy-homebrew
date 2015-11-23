class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.12.4.tar.gz"
  sha256 "e8a14138a564ec4aad79ff4ce063088356f7015796c757a0911e3b13c60180b5"

  bottle do
    cellar :any
    sha256 "de5d27dc70e119bdd17f15e8f4560e8c3d594f7b0760e8f4fb3a24711bc795c6" => :el_capitan
    sha256 "35c90b490b18799b7507621e80c54110f69800af0d515fd033e34dbf09b64540" => :yosemite
    sha256 "20f1cbb43647b86823942c78ac7661d01558c217e1d002818940257048fd5407" => :mavericks
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
