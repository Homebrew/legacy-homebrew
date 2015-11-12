class Isync < Formula
  desc "Synchronize a maildir with an IMAP server"
  homepage "http://isync.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.2.0/isync-1.2.0.tar.gz"
  sha256 "833878de1647d403cb56984757cc416094ee037c5388a0f1d1f74084f6e60e59"

  bottle do
    cellar :any
    sha256 "fc87f507e7829efabb36b97c5a6e10647d161146f31cc66b52277823ef8c3633" => :yosemite
    sha256 "f67194154a8b332576088dd8eca6ed862a5c34c40ab19aa55c70bcaf698bda75" => :mavericks
    sha256 "efc6fc775a01acbd16f20adf3b6c0e32b13d8400519a913a420fee81fc4b54f9" => :mountain_lion
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
