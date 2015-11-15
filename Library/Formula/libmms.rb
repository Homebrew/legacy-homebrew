class Libmms < Formula
  desc "Library for parsing mms:// and mmsh:// network streams"
  homepage "https://sourceforge.net/projects/libmms/"
  url "https://downloads.sourceforge.net/project/libmms/libmms/0.6.4/libmms-0.6.4.tar.gz"
  sha256 "3c05e05aebcbfcc044d9e8c2d4646cd8359be39a3f0ba8ce4e72a9094bee704f"

  bottle do
    cellar :any
    revision 2
    sha256 "61c4dd24598198386342dd9c700e218b6b83c82627efc781daa89acfaca96066" => :el_capitan
    sha256 "f915d916dd81ad9f767b6905e166dae07df72e70dc0c844c8011abed9f144252" => :yosemite
    sha256 "b55ae55a0d684ba1e3654eee96769d206ce0c22a4ab7bad5241eb1c51bda7778" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  # https://trac.macports.org/ticket/27988
  if MacOS.version <= :leopard
    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/patches/1fac7062/libmms/src_mms-common.h.patch"
      sha256 "773193b878b7c061f05fe76f0ea5d331b8ab3e7b348608fae8cb144139e94798"
    end
  end

  def install
    ENV.append "LDFLAGS", "-liconv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
