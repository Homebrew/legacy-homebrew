require "formula"

class Pazpar2 < Formula
  homepage "http://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.8.6.tar.gz"
  sha1 "9be3bb03117a6f73e3219ca3e70568fcc95f4225"

  bottle do
    cellar :any
    sha256 "8f22c771c8341071871fd9fff8054025386943dc59cb8edc5298c9605965393c" => :yosemite
    sha256 "05d0fd2ab91d7003286cce1ef163e1b8e7bc38535bc5e07302cf18dedc09ee28" => :mavericks
    sha256 "ab41296713209accfe85f66c905442c34912f210c7fa5448f55d5c5f946ef704" => :mountain_lion
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
