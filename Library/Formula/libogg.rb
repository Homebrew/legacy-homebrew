require 'formula'

class Libogg < Formula
  homepage 'http://www.xiph.org/ogg/'
  url 'http://downloads.xiph.org/releases/ogg/libogg-1.3.1.tar.gz'
  sha1 '270685c2a3d9dc6c98372627af99868aa4b4db53'

  bottle do
    cellar :any
    sha1 "925af318955228698a49274ad4d8fdf159516476" => :mavericks
    sha1 "097ab6c63f37d1e5c87c1f1d537ba544dcb00690" => :mountain_lion
    sha1 "01f043b7262c73bce7bb2cb5237e90ee91462b58" => :lion
  end

  head do
    url 'http://svn.xiph.org/trunk/ogg'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make install"
  end
end
