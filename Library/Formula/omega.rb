class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "http://xapian.org"
  url "http://oligarchy.co.uk/xapian/1.2.18/xapian-omega-1.2.18.tar.xz"
  sha256 "528feb8021a52ab06c7833cb9ebacefdb782f036e99e7ed5342046c3a82380c2"

  bottle do
    sha256 "29e89b142dcfb969ebb56efa7210964c2043de3b363e99a5fde9908c254b54b0" => :mavericks
    sha256 "6c49cda8bf44de8f2a11248bbb6f3e1c5d6054765d27db093c942b17c5449eb8" => :mountain_lion
    sha256 "e8a5b87a85315c7100f72035422773950c3544d0f024b910a2e225f04ea7dad3" => :lion
  end

  depends_on "pcre"
  depends_on "xapian"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/omindex", "--db", "./test", "--url", "/", "#{share}/doc/xapian-omega"
    assert File.exist?("./test/flintlock")
  end
end
