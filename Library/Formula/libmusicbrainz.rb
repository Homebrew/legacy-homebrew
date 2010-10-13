require 'formula'

class Libmusicbrainz <Formula
  url 'http://ftp.musicbrainz.org/pub/musicbrainz/libmusicbrainz-3.0.2.tar.gz'
  homepage 'http://musicbrainz.org'
  md5 '648ecd43f7b80852419aaf73702bc23f'

  depends_on 'neon'

  def install
    neon = Formula.factory("neon")
    neon_args = "-DNEON_LIBRARIES:FILEPATH=#{neon.lib}/libneon.dylib -DNEON_INCLUDE_DIR:PATH=#{neon.include}/neon"

    system "cmake . #{std_cmake_parameters} #{neon_args}"
    system "make install"
  end
end