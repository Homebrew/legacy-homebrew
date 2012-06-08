require 'formula'

class H264bitstream < Formula
  url 'http://downloads.sourceforge.net/project/h264bitstream/h264bitstream/0.1.9/h264bitstream-0.1.9.tar.gz'
  homepage 'http://h264bitstream.sourceforge.net/'
  md5 '195fc962a4fb38eaaa02c463b5df8d97'

  def install
    system './configure', "--prefix=#{prefix}"
    system 'make install'
  end
end
