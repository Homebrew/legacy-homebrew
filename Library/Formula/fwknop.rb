class Fwknop < Formula
  desc "Single Packet Authorization and Port Knocking"
  homepage "https://www.cipherdyne.org/fwknop/"
  url "https://github.com/mrash/fwknop/archive/2.6.7.tar.gz"
  sha256 "e96c13f725a4c3829c842743b14aedf591d30570df5c06556862a900b64def86"
  head "https://github.com/mrash/fwknop.git"

  bottle do
    sha256 "e61c96906e247525f0ab63c4804ce59061372c7cbf0cf5b82decfadad6d12ad7" => :el_capitan
    sha256 "d00d233db7cb2cb04c50ee792756d76cfda37f2c6bc210e313375dca01d8f4d1" => :yosemite
    sha256 "a69bbd4435378eb2b6b5a8046d3562aef0f22152b50521c106700aa53f221724" => :mavericks
    sha256 "c003419be9572eab4fa791bb43b4faa63235caadac15f3cb1d1f38b555b927ef" => :mountain_lion
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
