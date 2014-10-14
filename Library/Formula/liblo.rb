require 'formula'

class Liblo < Formula
  homepage 'http://liblo.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/liblo/liblo/0.28/liblo-0.28.tar.gz'
  sha1 '949d5f0c9919741c67602514786b9c7366fa001b'

  bottle do
    cellar :any
    sha1 "11823b01fdf501fd10ddce3574fd195468f3a841" => :mavericks
    sha1 "d28a2efa91b7b38b252319e4f8aac0d0d5fc8d4a" => :mountain_lion
    sha1 "882d2356ab21ab2258f7c3a9ee0d89f99053681d" => :lion
  end

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
