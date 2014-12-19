require "formula"

class Loudmouth < Formula
  homepage "http://mcabber.com"
  url "http://mcabber.com/files/loudmouth-1.5.0-20121201.tar.bz2"
  version "1.5.0.20121201"
  sha1 "502963c3068f7033bb21d788918c1e5cd14f386e"
  revision 1

  bottle do
    cellar :any
    sha1 "036bfd7eb2c9b064596bdbbf241bcd91247fbdb5" => :yosemite
    sha1 "ea2c830197162a650c5b24b6e86b78f1ef9e878f" => :mavericks
    sha1 "0b77821cecfa2ea9e3cd9789c21b2e8857f43be0" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libidn"
  depends_on "gnutls"

  # Fix compilation on 10.9. Sent upstream:
  # https://github.com/mcabber/loudmouth/pull/9
  # Has been merged and will be in next release, if there is one.
  patch do
    url "https://github.com/mcabber/loudmouth/commit/369844a0fc.diff"
    sha1 "e52ee2e24a06ebea52b90866a347daf1f1d28382"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-ssl=gnutls"
    system "make", "install"
  end
end
