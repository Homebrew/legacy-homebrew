require "formula"

class Pazpar2 < Formula
  homepage "http://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.7.0.tar.gz"
  sha1 "3ea5faf6b67f092e34a8370a76ccb70b0f2964c6"

  bottle do
    cellar :any
    sha1 "d8875f865f73c7ee3cf1da16ecaa0be5753e63cf" => :mavericks
    sha1 "3acbdbe8ed8dc34d9c32ef3f1ebbde2a5eb9b41b" => :mountain_lion
    sha1 "c1ce9931a85031a2a30f400e0d88991a309229d7" => :lion
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
