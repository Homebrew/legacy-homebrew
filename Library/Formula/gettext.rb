require "formula"

class Gettext < Formula
  homepage "https://www.gnu.org/software/gettext/"
  url "http://ftpmirror.gnu.org/gettext/gettext-0.19.3.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gettext/gettext-0.19.3.tar.xz"
  sha256 "f6fdb29c9ee8ce85c7e574f60ff64fa91cf0f4f018437dfe800227d15595db46"
  revision 1

  bottle do
    sha1 "8be84a2bc42d358d4af8e2bc9520a7b5088cfb36" => :yosemite
    sha1 "a100e97a287b3ace08b19bb4aa897b23cab2df83" => :mavericks
    sha1 "20ab81180f28440f6cb734ac15aefe6001d4cce2" => :mountain_lion
  end

  keg_only :shadowed_by_osx, "OS X provides the BSD gettext library and some software gets confused if both are in the library path."

  option :universal

  def install
    ENV.libxml2
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
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
                          "--without-cvs",
                          "--without-xz"
    system "make"
    ENV.deparallelize # install doesn't support multiple make jobs
    system "make", "install"
  end
end
