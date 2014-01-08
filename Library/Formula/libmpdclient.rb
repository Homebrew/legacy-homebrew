require 'formula'

class Libmpdclient < Formula
  homepage 'http://www.musicpd.org/libs/libmpdclient/'
  url 'http://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.9.tar.gz'
  sha1 'fe40dcb54f79648a17b68c93add2e601077a9311'

  head do
    url 'git://git.musicpd.org/master/libmpdclient.git'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
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
