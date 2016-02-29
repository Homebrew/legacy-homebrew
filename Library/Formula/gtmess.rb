class Gtmess < Formula
  desc "Console MSN messenger client"
  homepage "http://gtmess.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gtmess/gtmess/0.97/gtmess-0.97.tar.gz"
  sha256 "606379bb06fa70196e5336cbd421a69d7ebb4b27f93aa1dfd23a6420b3c6f5c6"
  revision 1

  bottle do
    sha256 "4e13b036917a9a793db1feaf3a3b79b4815f75ed4924963c8cc0ef8a114ced1d" => :el_capitan
    sha256 "a9afe5b901bd068aa32834df9eca85e3f63ef510ecbb8854cd8bdc8e1b6eb66d" => :yosemite
    sha256 "894f4d6e076d77a83aaeb05d6eac7f21551f7de9864b391aaf710613693bdb1c" => :mavericks
    sha256 "b2069daa0f9d6f69510db8f7351fe41bf2728b7f9ec7bce4b26bc0c24bf3abd8" => :mountain_lion
  end

  head do
    url "https://github.com/geotz/gtmess.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end
end
