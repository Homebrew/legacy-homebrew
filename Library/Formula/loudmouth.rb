require "formula"

class Loudmouth < Formula
  homepage "http://mcabber.com"
  url "http://mcabber.com/files/loudmouth-1.5.0-20121201.tar.bz2"
  version "1.5.0.20121201"
  sha1 "502963c3068f7033bb21d788918c1e5cd14f386e"
  revision 1

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
