class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "http://mailutils.org/"
  url "http://ftpmirror.gnu.org/mailutils/mailutils-2.2.tar.gz"
  sha256 "97591debcd32ac1f4c4d16eaa8f21690d9dfefcb79e29bd293871d57c4a5e05d"

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
