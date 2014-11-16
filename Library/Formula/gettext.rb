require "formula"

class Gettext < Formula
  homepage "https://www.gnu.org/software/gettext/"
  url "http://ftpmirror.gnu.org/gettext/gettext-0.19.3.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gettext/gettext-0.19.3.tar.xz"
  sha256 "f6fdb29c9ee8ce85c7e574f60ff64fa91cf0f4f018437dfe800227d15595db46"

  bottle do
    sha1 "9ec1f76ee701c724a0f5fd173437b74ceaa4b05a" => :yosemite
    sha1 "8e94d136e0e9bdab19155e08a78c35e9691e50cf" => :mavericks
    sha1 "dc373eedc56725b494be8f340e374b59b841d8c6" => :mountain_lion
    sha1 "c78b336ceaa699f4186ed4f56e0c641c11e47cc9" => :lion
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
