class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "http://ftpmirror.gnu.org/gettext/gettext-0.19.6.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gettext/gettext-0.19.6.tar.xz"
  sha256 "9b95816620fd1168cb4eeca0e9dc0ffd86e864fc668f76f5e37cc054d6982e51"

  bottle do
    sha256 "8df50085d6a552958805922ce4b25ec2d57e6f0799b4a5549778bce2b1ba0b49" => :el_capitan
    sha256 "b28fcdcc79bfd01f3750ef564064feac7b4f8d7d19ed1b92176684293c5016a9" => :yosemite
    sha256 "cc788fa52512f86ee271cdba9591aef6ff3905f5343b3b970359f15d16461043" => :mavericks
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
                          "--with-lispdir=#{share}/emacs/site-lisp/gettext",
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

  test do
    system "#{bin}/gettext", "test"
  end
end
