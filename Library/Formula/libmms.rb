class Libmms < Formula
  desc "Library for parsing mms:// and mmsh:// network streams"
  homepage "http://sourceforge.net/projects/libmms/"
  url "https://downloads.sourceforge.net/project/libmms/libmms/0.6.4/libmms-0.6.4.tar.gz"
  sha256 "3c05e05aebcbfcc044d9e8c2d4646cd8359be39a3f0ba8ce4e72a9094bee704f"

  bottle do
    cellar :any
    revision 1
    sha256 "91e62cb832cfb39c8a7ed406fcc7ddd1b7cbc0cb5282394d553b43d54f394863" => :el_capitan
    sha1 "775dd094b8e1d7ac7a8466321241341f8f05be2e" => :yosemite
    sha1 "ccc9dc73c3512d932d529853398199fc3995a84f" => :mavericks
    sha1 "38786ae43d15c27862bd003e1fc779c24e2f1863" => :mountain_lion
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
