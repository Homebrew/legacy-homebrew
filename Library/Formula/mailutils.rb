require "formula"

class Mailutils < Formula
  homepage "http://mailutils.org/"
  url "http://ftpmirror.gnu.org/mailutils/mailutils-2.2.tar.gz"
  sha1 "166a47c5eef6192542b568e031719c3e8d01d1f5"

  depends_on "gnutls"
  depends_on "gsasl"

  def install
    # Python breaks the build (2014-05-01)
    # Don't want bin/mu-mh/ directory
    system "./configure", "--without-python",
                          "--disable-mh",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/movemail", "--version"
  end
end
