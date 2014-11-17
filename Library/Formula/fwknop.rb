require "formula"

class Fwknop < Formula
  homepage "http://www.cipherdyne.org/fwknop/"
  head "https://github.com/mrash/fwknop.git"
  url "https://github.com/mrash/fwknop/archive/2.6.4.tar.gz"
  sha1 "b13ef022ade7da6dc5b08335d5a1d29dd898887b"
  revision 1

  bottle do
    sha1 "1708a7d273a2b70ca61d9e34189fc9e1cb2cd1f0" => :yosemite
    sha1 "16dd1174e3a4ef880d54bf24a98fc26719117480" => :mavericks
    sha1 "9e8176ccc32ffecd6d39b10c8930fec0fcb2e1ca" => :mountain_lion
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "wget" => :optional
  depends_on "gpgme"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--disable-silent-rules",
                          "--prefix=#{prefix}", "--with-gpgme",
                          "--with-gpg=#{Formula["gnupg2"].opt_prefix}/bin/gpg2"
    system "make", "install"
  end

  test do
    system "#{bin}/fwknop", "--version"
  end
end
