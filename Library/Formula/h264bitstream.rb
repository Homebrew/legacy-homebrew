require 'formula'

class H264bitstream < Formula
  homepage 'http://h264bitstream.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/h264bitstream/h264bitstream/0.1.9/h264bitstream-0.1.9.tar.gz'
  sha1 '5e12e765641e76f86b794f939bf99405c4e4d373'

  def install
    system './configure', "--prefix=#{prefix}"
    system 'make install'
  end
end
