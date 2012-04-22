require 'formula'

class Libmusicbrainz < Formula
  homepage 'http://musicbrainz.org/doc/libmusicbrainz'
  url 'https://github.com/downloads/musicbrainz/libmusicbrainz/libmusicbrainz-4.0.1.tar.gz'
  md5 '3fe4e869f69dc83a4427b5d5c52580ef'

  depends_on 'neon'
  depends_on 'cmake' => :build

  def install
    neon = Formula.factory("neon")
    neon_args = "-DNEON_LIBRARIES:FILEPATH=#{neon.lib}/libneon.dylib -DNEON_INCLUDE_DIR:PATH=#{neon.include}/neon"

    system "cmake #{std_cmake_parameters} #{neon_args} ."
    system "make install"
  end
end
