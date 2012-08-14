require 'formula'

class Libmusicbrainz < Formula
  homepage 'http://musicbrainz.org/doc/libmusicbrainz'
  url 'https://github.com/downloads/metabrainz/libmusicbrainz/libmusicbrainz-5.0.1.tar.gz'
  md5 'a0406b94c341c2b52ec0fe98f57cadf3'

  depends_on 'neon'
  depends_on 'cmake' => :build

  def install
    neon = Formula.factory("neon")
    neon_args = %W[-DNEON_LIBRARIES:FILEPATH=#{neon.lib}/libneon.dylib
                 -DNEON_INCLUDE_DIR:PATH=#{neon.include}/neon]
    system "cmake", ".", *(std_cmake_args + neon_args)
    system "make install"
  end
end
