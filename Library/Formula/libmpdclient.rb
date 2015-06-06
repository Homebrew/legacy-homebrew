require 'formula'

class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage 'http://www.musicpd.org/libs/libmpdclient/'
  url 'http://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.10.tar.gz'
  sha1 '106de0e8f0e63ec3899c91c38d1bcc171df61637'

  bottle do
    cellar :any
    sha1 "9be910acd8278521e8f43b20448f31d7bb841ca5" => :yosemite
    sha1 "a5e180c855e756a33049a7f5aa4b2b4776cb6967" => :mavericks
    sha1 "e7e1ea43d44615bdacb1d4bb06ad8e4413e30ac2" => :mountain_lion
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
