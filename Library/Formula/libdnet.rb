require 'formula'

class Libdnet < Formula
  homepage 'http://code.google.com/p/libdnet/'
  url 'http://libdnet.googlecode.com/files/libdnet-1.12.tgz'
  sha1 '71302be302e84fc19b559e811951b5d600d976f8'

  depends_on :automake
  depends_on :libtool

  option 'with-python', 'Build Python module'

  def install
    # autoreconf to get '.dylib' extension on shared lib
    ENV['ACLOCAL'] = 'aclocal -I config'
    system 'autoreconf', '-ivf'

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]
    args << "--with-python" if build.include? "with-python"
    system "./configure", *args
    system "make install"
  end
end
