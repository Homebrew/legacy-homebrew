class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "http://ftpmirror.gnu.org/gettext/gettext-0.19.5.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gettext/gettext-0.19.5.1.tar.xz"
  sha256 "66da00dc2c810d733b1f55a2a4af5cb669e2ee4259937d50a51d5614cdad323d"

  bottle do
    sha256 "2d656826a18a00ae28d622566903421fb8f7ff5baecd7b77ad9606bf5859cd62" => :yosemite
    sha256 "c03c783c1a9af0599a1715460618d166a8b603d4373e5a81b3278ade18ce1a2a" => :mavericks
    sha256 "8b1a9526779ec7b607e2b67c4ccfd271401d8ee7fedc98ee260da21e25906867" => :mountain_lion
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
