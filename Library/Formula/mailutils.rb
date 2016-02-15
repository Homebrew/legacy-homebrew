class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "http://mailutils.org/"
  url "http://ftpmirror.gnu.org/mailutils/mailutils-2.2.tar.gz"
  sha256 "97591debcd32ac1f4c4d16eaa8f21690d9dfefcb79e29bd293871d57c4a5e05d"
  revision 1

  bottle do
    sha256 "fccedf57a8a126a59070d2038ff46b5fc12ef98a2e5d4a670d43360258904471" => :el_capitan
    sha256 "2b427bbb6d4043c70441b037916ca60a0abb2bdbc78c255162d63f87bbdce86c" => :yosemite
    sha256 "79fb430c09ce7803450a55d8be2185d62bb1c3b6bd880ff76826928a067a9453" => :mavericks
  end

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
