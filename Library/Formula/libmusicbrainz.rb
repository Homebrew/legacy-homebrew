require 'formula'

class Libmusicbrainz < Formula
  homepage 'http://musicbrainz.org'
  if ARGV.build_devel?
    version '4.0.0beta1'
    url 'ftp://ftp.musicbrainz.org/pub/musicbrainz/libmusicbrainz-4.0.0beta1.tar.gz'
    md5 '7dffa8fa08e4c0bc8119b8f48a15da41'
  else
    url 'http://ftp.musicbrainz.org/pub/musicbrainz/libmusicbrainz-3.0.3.tar.gz'
    md5 'f4824d0a75bdeeef1e45cc88de7bb58a'
  end

  depends_on 'neon'
  depends_on 'cmake' => :build

  def install
    neon = Formula.factory("neon")
    neon_args = "-DNEON_LIBRARIES:FILEPATH=#{neon.lib}/libneon.dylib -DNEON_INCLUDE_DIR:PATH=#{neon.include}/neon"

    system "cmake . #{std_cmake_parameters} #{neon_args}"
    system "make install"
  end
end
