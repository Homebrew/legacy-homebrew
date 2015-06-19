class Webalizer < Formula
  desc "Web server log file analysis"
  homepage "http://www.webalizer.org"
  url "ftp://ftp.mrunix.net/pub/webalizer/webalizer-2.23-08-src.tgz"
  mirror "https://mirrors.kernel.org/debian/pool/main/w/webalizer/webalizer_2.23.08.orig.tar.gz"
  sha256 "edaddb5aa41cc4a081a1500e3fa96615d4b41bc12086bcedf9938018ce79ed8d"

  bottle do
    sha256 "65ef54216360d45dc10285e8e12f1381ad273093ad4e88c3d659d91f8f4d63eb" => :yosemite
    sha256 "0910ecb43a791249be8eb075ea012868fea97d704f49a0d1ae3ec246ff169f4f" => :mavericks
    sha256 "3677442a19563ad21e7f5e2b3d7e6335cd388a8e9ca0223d4012ee5787c3f503" => :mountain_lion
  end

  depends_on "gd"
  depends_on "berkeley-db"
  depends_on "libpng"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.log").write "127.0.0.1 user-identifier homebrew [10/Oct/2000:13:55:36 -0700] \"GET /beer.gif HTTP/1.0\" 200 2326"
    system "#{bin}/webalizer", "-c", etc/"webalizer.conf.sample", testpath/"test.log"
    assert File.exist? "usage.png"
    assert File.exist? "index.html"
  end
end
