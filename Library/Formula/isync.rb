class Isync < Formula
  homepage "http://isync.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.1.2/isync-1.1.2.tar.gz"
  sha256 "a225b5d5915b6e0f9da303caa6b4db1ee06241e98c1ad0a662e5dcea0654c0a4"

  head do
    url "git://git.code.sf.net/p/isync/isync"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "berkeley-db"
  depends_on "openssl"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"get-cert", "duckduckgo.com:443"
  end
end
