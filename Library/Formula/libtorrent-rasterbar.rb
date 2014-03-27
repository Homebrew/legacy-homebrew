require 'formula'

class LibtorrentRasterbar < Formula
  homepage 'http://www.rasterbar.com/products/libtorrent/'
  url 'https://downloads.sourceforge.net/project/libtorrent/libtorrent/libtorrent-rasterbar-0.16.15.tar.gz'
  sha1 '8657a493fb2ee4e6bf55e484deb922d23b65818d'

  depends_on 'pkg-config' => :build
  depends_on 'boost'
  depends_on 'openssl' if MacOS.version <= :snow_leopard # Needs a newer version of OpenSSL on Snow Leopard
  depends_on :python => :recommended

  def install
    boost = Formula["boost"]

    optional_args = []
    if build.with? "python"
      optional_args << "--enable-python-binding"
      optional_args << "--with-boost-python=boost_python-mt"
      optional_args << "PYTHON_EXTRA_LDFLAGS= "
    end

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{boost.opt_prefix}",
                          *optional_args
    system "make install"
  end
end
