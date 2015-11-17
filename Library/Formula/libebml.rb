class Libebml < Formula
  desc "Sort of a sbinary version of XML"
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
    sha256 "4f4a4af564ec57747b83f65ea4b6e1f58ebc1bdad0be545825ddea6dcf4b9708" => :el_capitan
    sha1 "5e3f974d17bd9f6fad89d19c403e3fd720f6c509" => :yosemite
    sha1 "8bbd297bdca1e250bedf9f9a1800a8819fa97d34" => :mavericks
    sha1 "c1ea1c44a4653770dd92ecfa64561f8f449f1da2" => :mountain_lion
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
