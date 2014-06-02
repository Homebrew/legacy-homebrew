require "formula"

class Gettext < Formula
  homepage "https://www.gnu.org/software/gettext/"
  url "http://ftpmirror.gnu.org/gettext/gettext-0.19.2.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gettext/gettext-0.19.2.tar.xz"
  sha256 "b34e1baaf37e56b4f5d7104353a437a735b2e094a70588e7c5ae671eaa0819c3"

  bottle do
    sha1 "b051e525a42aa11242dc80afd19aa914d38b1e4b" => :mavericks
    sha1 "a1e9a0835d6f2ac2134ac3583e40ac3e4315c5d0" => :mountain_lion
    sha1 "674f284e9fb6be58df47b788a84eaa5a0c64d195" => :lion
  end

  keg_only "OS X provides the BSD gettext library and some software gets confused if both are in the library path."

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
    system "make install"
  end
end
