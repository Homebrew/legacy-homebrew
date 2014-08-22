require "formula"

class Pazpar2 < Formula
  homepage "http://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.7.2.tar.gz"
  sha1 "bf888afea5d6da0127623360e5e223ad5116be2e"

  bottle do
    cellar :any
    sha1 "236a66e68795e025eb4254c7fc9a4943a061dcdf" => :mavericks
    sha1 "afc5a5c73e86a408eddaa53663f24280ff8ce7de" => :mountain_lion
    sha1 "b1cde892f7a25f78bf2f25826c674b7007cefc2b" => :lion
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
