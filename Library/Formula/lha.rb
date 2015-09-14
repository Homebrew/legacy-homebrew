class Lha < Formula
  desc "Utility for creating and opening lzh archives"
  homepage "https://lha.osdn.jp"
  url "http://dl.osdn.jp/lha/22231/lha-1.14i-ac20050924p1.tar.gz"
  version "1.14i-ac20050924p1"
  sha256 "b5261e9f98538816aa9e64791f23cb83f1632ecda61f02e54b6749e9ca5e9ee4"

  head do
    url "http://scm.osdn.jp/gitroot/lha/lha.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "autoreconf", "-is" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/lha", "c", "foo.lzh", "foo"
    assert_equal "::::::::\nfoo\n::::::::\ntest", shell_output("#{bin}/lha p foo.lzh")
  end
end
