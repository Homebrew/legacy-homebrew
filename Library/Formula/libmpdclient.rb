require 'formula'

class Libmpdclient < Formula
  homepage 'http://mpd.wikia.com/wiki/ClientLib:libmpdclient'
  url 'http://downloads.sourceforge.net/project/musicpd/libmpdclient/2.7/libmpdclient-2.7.tar.bz2'
  sha1 'a8ec78f6a7ae051fbf1cc0f47564301423c281b0'

  head do
    url 'git://git.musicpd.org/master/libmpdclient.git'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
    depends_on 'doxygen' => :build
  end

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
