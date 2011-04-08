require 'formula'

class Libmusicbrainz < Formula
  url 'http://ftp.musicbrainz.org/pub/musicbrainz/libmusicbrainz-3.0.3.tar.gz'
  homepage 'http://musicbrainz.org'
  md5 'f4824d0a75bdeeef1e45cc88de7bb58a'

  depends_on 'neon'
  depends_on 'cmake' => :build

  def install
    neon = Formula.factory("neon")
    neon_args = "-DNEON_LIBRARIES:FILEPATH=#{neon.lib}/libneon.dylib -DNEON_INCLUDE_DIR:PATH=#{neon.include}/neon"

    system "cmake . #{std_cmake_parameters} #{neon_args}"
    system "make install"
  end
end
