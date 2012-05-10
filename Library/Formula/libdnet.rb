require 'formula'

class Libdnet < Formula
  url 'http://libdnet.googlecode.com/files/libdnet-1.12.tgz'
  homepage 'http://code.google.com/p/libdnet/'
  md5 '9253ef6de1b5e28e9c9a62b882e44cc9'

  if ARGV.build_head? and MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def options
    [['--with-python', 'Build Python module too.']]
  end

  def install
    # autoreconf to get '.dylib' extension on shared lib
    ENV['ACLOCAL'] = 'aclocal -I config'
    system 'autoreconf', '-ivf'

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]
    args << "--with-python" if ARGV.include? "--with-python"
    system "./configure", *args
    system "make install"
  end
end
