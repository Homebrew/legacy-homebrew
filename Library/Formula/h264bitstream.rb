class H264bitstream < Formula
  desc "Library for reading and writing H264 video streams"
  homepage "http://h264bitstream.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/h264bitstream/h264bitstream/0.1.9/h264bitstream-0.1.9.tar.gz"
  sha256 "a18dee311adf6533931f702853b39058b1b7d0e484d91b33c6ba6442567d4764"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
