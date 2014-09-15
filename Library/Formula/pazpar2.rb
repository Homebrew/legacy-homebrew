require "formula"

class Pazpar2 < Formula
  homepage "http://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.7.5.tar.gz"
  sha1 "c1249c0e797b36e00b1ae012508cb82354bf40bd"

  bottle do
    cellar :any
    sha1 "20715656bf932725526fab7e2a17f48cc67cb423" => :mavericks
    sha1 "d1a96a387cdf3cae06a5420ea6deebe79aea0556" => :mountain_lion
    sha1 "ff097df6804cf36ab1ba069dce7a11ea1a38728f" => :lion
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
