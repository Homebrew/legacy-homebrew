require 'formula'

class Libmusicbrainz < Formula
  homepage 'http://musicbrainz.org/doc/libmusicbrainz'
  url 'https://github.com/downloads/metabrainz/libmusicbrainz/libmusicbrainz-5.0.1.tar.gz'
  sha1 'd4823beeca3faf114756370dc7dd6e3cd01d7e4f'

  depends_on 'cmake' => :build
  depends_on 'neon'

  def install
    neon = Formula.factory("neon")
    neon_args = %W[-DNEON_LIBRARIES:FILEPATH=#{neon.lib}/libneon.dylib
                 -DNEON_INCLUDE_DIR:PATH=#{neon.include}/neon]
    system "cmake", ".", *(std_cmake_args + neon_args)
    system "make install"
  end
end
