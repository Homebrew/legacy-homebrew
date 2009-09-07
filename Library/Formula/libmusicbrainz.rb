require 'brewkit'

class Libmusicbrainz <Formula
  @url='http://ftp.musicbrainz.org/pub/musicbrainz/libmusicbrainz-3.0.2.tar.gz'
  @homepage='http://musicbrainz.org'
  @md5='648ecd43f7b80852419aaf73702bc23f'

  def deps
    { :required => 'neon', :optional => 'libdiscid' }
  end

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end