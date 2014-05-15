require 'formula'

class LibtorrentRasterbar < Formula
  homepage 'http://www.rasterbar.com/products/libtorrent/'
  url 'https://downloads.sourceforge.net/project/libtorrent/libtorrent/libtorrent-rasterbar-0.16.16.tar.gz'
  sha1 'de8faed5cbc09baddb2748cb7b75edd07ab0addc'

  bottle do
    cellar :any
    sha1 "ccfa9b86a5a20f6da9e72918d33b4ecca846e313" => :mavericks
    sha1 "2ed7bef9d8089695338a3780395da8813d95435f" => :mountain_lion
    sha1 "73888143ab640425dae0e8826f809369e55f06dd" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'boost'
  depends_on 'openssl' if MacOS.version <= :snow_leopard # Needs a newer version of OpenSSL on Snow Leopard
  depends_on :python => :optional

  def install
    boost = Formula["boost"]

    args = [ "--disable-debug",
             "--disable-dependency-tracking",
             "--prefix=#{prefix}",
             "--with-boost=#{boost.opt_prefix}" ]

    # Build python bindings requires forcing usage of the mt version of boost_python.
    # Be aware that if using a brewed python, boost will have to be built from source
    # to ensure that boost_python is linked against the brewed python runtime.
    if build.with? "python"
      args << "--enable-python-binding"
      args << "--with-boost-python=boost_python-mt"
      args << "PYTHON_EXTRA_LDFLAGS= "
    end

    system "./configure", *args
    system "make install"
  end
end
