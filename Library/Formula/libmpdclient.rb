require 'formula'

class Libmpdclient < Formula
  homepage 'http://www.musicpd.org/libs/libmpdclient/'
  url 'http://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.9.tar.gz'
  sha1 'fe40dcb54f79648a17b68c93add2e601077a9311'

  bottle do
    cellar :any
    sha1 "ef4d88441280126e529c9b9297af502816ef920c" => :mavericks
    sha1 "2e7c01d9185c23bc88f1e04aab7b70368decb17f" => :mountain_lion
    sha1 "8dba6c7353ac4a88d21a52af3ce36ba1a558aed9" => :lion
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
