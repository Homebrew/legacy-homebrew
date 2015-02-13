class Libebml < Formula
  homepage "http://www.matroska.org/"
  url "http://dl.matroska.org/downloads/libebml/libebml-1.3.1.tar.bz2"
  mirror "https://www.bunkus.org/videotools/mkvtoolnix/sources/libebml-1.3.1.tar.bz2"
  sha256 "195894b31aaca55657c9bc157d744f23b0c25597606b97cfa5a9039c4b684295"

  head do
    url "https://github.com/Matroska-Org/libebml.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    revision 1
    sha1 "50c10f93ac4f4d5d4f63d26b3175e2809dea4a0c" => :yosemite
    sha1 "ce19e183dee7ed41071fade3518a6ddcd7481aef" => :mavericks
  end

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    system "autoreconf", "-fi" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
