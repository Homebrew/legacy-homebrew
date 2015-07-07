class Isync < Formula
  desc "Synchronize a maildir with an IMAP server"
  homepage "http://isync.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.1.2/isync-1.1.2.tar.gz"
  sha256 "a225b5d5915b6e0f9da303caa6b4db1ee06241e98c1ad0a662e5dcea0654c0a4"

  bottle do
    cellar :any
    sha256 "0b8fc50a95165b6ad862459e389f1ad3d7aae5895e0ba401e41881e75ba8ea46" => :yosemite
    sha256 "5283c962829e28ab17a612f7fa6ea99b23f1873a99b33f826bd9f8db07adc2a1" => :mavericks
    sha256 "cf13b07b43c977ceb5ab7ca1df216127b05f9ea522a689bddb686d9828ed9e5d" => :mountain_lion
  end

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
