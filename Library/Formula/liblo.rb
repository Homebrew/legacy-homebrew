require 'formula'

class Liblo < Formula
  homepage 'http://liblo.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/liblo/liblo/0.27/liblo-0.27.tar.gz'
  sha1 'bbd92eb9ab7316ee3f75b6b887b6f853b848c1e5'

  head do
    url 'git://liblo.git.sourceforge.net/gitroot/liblo/liblo'

    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
    depends_on 'libtool' => :build
  end

  option "enable-ipv6", "Compile with support for ipv6"
  option :universal

  def install
    ENV.universal_binary if build.universal?

    args = %W[--disable-debug
              --disable-dependency-tracking
              --prefix=#{prefix}]

    args << "--enable-ipv6" if build.include? "enable-ipv6"

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make install"
  end
end
