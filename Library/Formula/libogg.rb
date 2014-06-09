require 'formula'

class Libogg < Formula
  homepage 'https://www.xiph.org/ogg/'
  url 'http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz'
  sha1 'df7f3977bbeda67306bc2a427257dd7375319d7d'

  bottle do
    cellar :any
    sha1 "7fcbece23ab93ac6d107625aae32e966615661d1" => :mavericks
    sha1 "ba0b0f47f7043e711eb8ab3719623d15395440ab" => :mountain_lion
    sha1 "e5f0cb6f5b1546e8073cdaa9b09b65b8b7c0d696" => :lion
  end

  head do
    url 'https://svn.xiph.org/trunk/ogg'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
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
