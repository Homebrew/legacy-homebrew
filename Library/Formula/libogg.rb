require 'formula'

class Libogg < Formula
  homepage 'https://www.xiph.org/ogg/'
  url 'http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz'
  sha1 'df7f3977bbeda67306bc2a427257dd7375319d7d'

  bottle do
    cellar :any
    sha1 "925af318955228698a49274ad4d8fdf159516476" => :mavericks
    sha1 "097ab6c63f37d1e5c87c1f1d537ba544dcb00690" => :mountain_lion
    sha1 "01f043b7262c73bce7bb2cb5237e90ee91462b58" => :lion
  end

  head do
    url 'https://svn.xiph.org/trunk/ogg'

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
