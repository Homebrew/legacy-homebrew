require 'formula'

class Liblo < Formula
  homepage 'http://liblo.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/liblo/liblo/0.26/liblo-0.26.tar.gz'
  sha1 '21942c8f19e9829b5842cb85352f98c49dfbc823'

  head 'git://liblo.git.sourceforge.net/gitroot/liblo/liblo'

  if build.head?
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
