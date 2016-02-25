class Fwknop < Formula
  desc "Single Packet Authorization and Port Knocking"
  homepage "https://www.cipherdyne.org/fwknop/"
  url "https://github.com/mrash/fwknop/archive/2.6.8.tar.gz"
  sha256 "96e6ba8b7e29aaf65bd06eaa823896ab66169b2aaced8123375378ff4b76a2d6"
  head "https://github.com/mrash/fwknop.git"

  bottle do
    sha256 "fd2b5c7e993a76dc242e75b69776a2228a7eb1e6721756c9a978478e2fa14828" => :el_capitan
    sha256 "4c4ef1ddfcf4c59dde5c1bf31571917c699db67b08c5ca03002be82ede022302" => :yosemite
    sha256 "60bc661b9d289ae9f20b7f80b8d11e0d2823994358d329bd6439006f9b94ce1a" => :mavericks
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "wget" => :optional
  depends_on "gpgme"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--disable-silent-rules",
                          "--prefix=#{prefix}", "--with-gpgme", "--sysconfdir=#{etc}",
                          "--with-gpg=#{Formula["gnupg2"].opt_prefix}/bin/gpg2"
    system "make", "install"
  end

  test do
    touch testpath/".fwknoprc"
    chmod 0600, testpath/".fwknoprc"
    system "#{bin}/fwknop", "--version"
  end
end
