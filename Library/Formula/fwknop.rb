class Fwknop < Formula
  homepage "http://www.cipherdyne.org/fwknop/"
  head "https://github.com/mrash/fwknop.git"
  url "https://github.com/mrash/fwknop/archive/2.6.5.tar.gz"
  sha1 "52f5a191f37aeeb2716d2ad5a25dbf41d6593100"

  bottle do
    sha1 "f82b7596356044e1b6b0c41ede54bfcc11b3585a" => :yosemite
    sha1 "6488990ef06c578ab92c6fb74dd0b3af24e5c934" => :mavericks
    sha1 "20fc1fc8b38e1e24d33f1d7197aa1dae5dbc9d70" => :mountain_lion
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
    ENV["HOME"] = testpath
    touch testpath/".fwknoprc"
    chmod 0600, testpath/".fwknoprc"
    system "#{bin}/fwknop", "--version"
  end
end
