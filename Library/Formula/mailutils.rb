require "formula"

class Mailutils < Formula
  homepage "http://mailutils.org/"
  url "http://ftpmirror.gnu.org/mailutils/mailutils-2.2.tar.gz"
  sha1 "166a47c5eef6192542b568e031719c3e8d01d1f5"

  depends_on "gnutls"
  depends_on "gsasl"

  def install
    system "./configure",
      "--without-python",       # Breaks the build (2014-05-01)
      "--disable-mh",           # Don't want `bin/mu-mh/' directory
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/movemail", "--version"
  end
end
