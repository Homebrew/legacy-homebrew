require "formula"

class Pazpar2 < Formula
  homepage "http://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.8.2.tar.gz"
  sha1 "a322e6a668c283aa43570fafbc63c7f4bafb1399"

  bottle do
    cellar :any
    sha1 "3913c1102f8eb27357a6ff823aa3c67694877943" => :yosemite
    sha1 "e811a8a27ec51af194963940717f3aa389e45f6b" => :mavericks
    sha1 "eeced70f699a306ea414f1be027a6b248806beff" => :mountain_lion
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
