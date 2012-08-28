require 'formula'

class LibtorrentRasterbar < Formula
  homepage 'http://www.rasterbar.com/products/libtorrent/'
  url  'http://libtorrent.googlecode.com/files/libtorrent-rasterbar-0.16.2.tar.gz'
  sha1 '04da641d21d0867fc103f4f57ffd41b3fce19ead'

  depends_on 'boost'

  def options
    [
      ["--enable-examples", "Build example executables including simple_client, client_test, dump_torrent, make_torrent, enum_if."],
      ["--enable-tests", "Build testing executables"],
      ["--enable-python-binding", "Build python bindings"],
    ]
  end

  def install
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      ]

    args << "--enable-examples" if ARGV.include? "--enable-examples"
    args << "--enable-tests" if ARGV.include? "--enable-tests"
    args << "--enable-python-binding" if ARGV.include? "--enable-python-binding"
    args << "--with-boost-python=boost_python-mt" if ARGV.include? "--enable-python-binding"

    system "./configure", *args
    system "make install"
  end
end
