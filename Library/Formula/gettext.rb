class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "http://ftpmirror.gnu.org/gettext/gettext-0.19.7.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gettext/gettext-0.19.7.tar.xz"
  sha256 "378fa86a091cec3acdece3c961bb8d8c0689906287809a8daa79dc0c6398d934"

  bottle do
    sha256 "3ee544b3eaff4f0616133cd256b48603763fa7b582e4d886961b94d27b74d33a" => :el_capitan
    sha256 "1acc727a92c9046ab8b16657e5863a4db7532f03218ffd7bc84bd1b9aeead1e4" => :yosemite
    sha256 "f3e204b797b20d43e7de42eb77cfa95f0b0a5c408e90f4248038b8336c398a13" => :mavericks
  end

  keg_only :shadowed_by_osx, "OS X provides the BSD gettext library and some software gets confused if both are in the library path."

  option :universal

  # https://savannah.gnu.org/bugs/index.php?46844
  depends_on "libxml2" if MacOS.version <= :mountain_lion

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
