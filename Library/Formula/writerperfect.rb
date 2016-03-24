class Writerperfect < Formula
  desc "Library for importing WordPerfect documents"
  homepage "https://sourceforge.net/p/libwpd/wiki/writerperfect/"
  url "https://downloads.sourceforge.net/project/libwpd/writerperfect/writerperfect-0.9.5/writerperfect-0.9.5.tar.xz"
  sha256 "aa01122659482627f9adcff91bb242c37092c7f8537bfa5dc44e1a3c89aad9e2"

  bottle do
    cellar :any
    sha256 "5443a58b0fe10cfadaf3977fca423c0289e2eba665244a5ebc020cbbbdfc78d6" => :el_capitan
    sha256 "9f7253806ba136c75dc4920f6eca864258a1b1021fce2e7ff5b772573b3b742e" => :yosemite
    sha256 "763ae44dd67dbbdb4b5d1efd8a749fd9c9ee32fb040aceb76696923a5b6ca815" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "libmwaw" => :optional
  depends_on "libodfgen"
  depends_on "libwps"
  depends_on "libwpg"
  depends_on "libwpd"
  depends_on "libetonyek" => :optional
  depends_on "libvisio" => :optional
  depends_on "libmspub" => :optional
  depends_on "libfreehand" => :optional
  depends_on "libcdr" => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
