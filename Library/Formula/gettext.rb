class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "http://ftpmirror.gnu.org/gettext/gettext-0.19.4.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gettext/gettext-0.19.4.tar.xz"
  sha256 "719adadb8bf3e36bac52c243a01c0add18d23506a3a40437e6f5899ceab18d20"

  bottle do
    sha1 "b1536310f96a0dfff5442b370dda06169cef92ab" => :yosemite
    sha1 "1720f95c4392d4f26d60f39c5722f99e91b09330" => :mavericks
    sha1 "0a94590e0d9a6546644b4b00015a5d8444cdf384" => :mountain_lion
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

  test do
    system "#{bin}/gettext", "test"
  end
end
