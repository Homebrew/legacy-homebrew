require "formula"

class Gettext < Formula
  homepage "https://www.gnu.org/software/gettext/"
  url "http://ftpmirror.gnu.org/gettext/gettext-0.19.3.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gettext/gettext-0.19.3.tar.xz"
  sha256 "f6fdb29c9ee8ce85c7e574f60ff64fa91cf0f4f018437dfe800227d15595db46"

  bottle do
    sha1 "d2a84c4dc0bcc7984e8a6232bff11780f21d16d3" => :mavericks
    sha1 "ca0f41730c2769d906d83e88d0aa4506350691fb" => :mountain_lion
    sha1 "0cf03a50241ea2383e8140cf974c5b0b5533f7b2" => :lion
  end

  keg_only :shadowed_by_osx, "OS X provides the BSD gettext library and some software gets confused if both are in the library path."

  option :universal

  def install
    ENV.libxml2
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-included-gettext",
                          "--with-included-glib",
                          "--with-included-libcroco",
                          "--with-included-libunistring",
                          "--with-emacs",
                          "--disable-java",
                          "--disable-csharp",
                          # Don't use VCS systems to create these archives
                          "--without-git",
                          "--without-cvs"
    system "make"
    ENV.deparallelize # install doesn't support multiple make jobs
    system "make", "install"
  end
end
