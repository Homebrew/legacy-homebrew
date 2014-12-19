require 'formula'

class Libmpdclient < Formula
  homepage 'http://www.musicpd.org/libs/libmpdclient/'
  url 'http://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.9.tar.gz'
  sha1 'fe40dcb54f79648a17b68c93add2e601077a9311'

  bottle do
    cellar :any
    revision 1
    sha1 "962769a096ef0fff79397f306cff35d5ba3c1600" => :yosemite
    sha1 "ae92204217c4bfec8d79dc24049dc4cac1adef07" => :mavericks
    sha1 "3c03b2e7a7624d7249c047e235a41469c29d05ee" => :mountain_lion
  end

  head do
    url 'git://git.musicpd.org/master/libmpdclient.git'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on 'doxygen' => :build

  option :universal

  def install
    inreplace 'autogen.sh', 'libtoolize', 'glibtoolize'
    system "./autogen.sh" if build.head?

    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
