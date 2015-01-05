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

  head "https://github.com/mcabber/loudmouth.git"

  head do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    # Fixes configure.ac subdir-objects for recent autoconf version
    # Remove this once the following pull request has been applied to master
    # https://github.com/mcabber/loudmouth/pull/11
    patch do
      url "https://github.com/languitar/loudmouth/commit/f22dd6.diff"
      sha1 "776f6c20259579e542ef588570956f26d71a46e5"
    end
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libidn"
  depends_on "gnutls"

  # Fix compilation on 10.9. Sent upstream:
  # https://github.com/mcabber/loudmouth/pull/9
  # Has been merged and will be in next release, if there is one.
  stable do
    patch do
      url "https://github.com/mcabber/loudmouth/commit/369844a0fc.diff"
      sha1 "e52ee2e24a06ebea52b90866a347daf1f1d28382"
    end
  end

  def install
    system "./autogen.sh", "-n" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-ssl=gnutls"
    system "make", "install"
  end
end
