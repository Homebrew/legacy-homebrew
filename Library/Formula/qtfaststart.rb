class Qtfaststart < Formula
  homepage "http://libav.org/"
  url "http://libav.org/releases/libav-11.2.tar.gz"
  sha256 "1f1448e1245444a1fae2f077f6846fedb47dfb294bef797e6742c095a6b4d769"

  resource "mov" do
    url "http://download.wavetlan.com/SVV/Media/HTTP/H264/Talkinghead_Media/H264_test4_Talkingheadclipped_mov_480x320.mov"
    sha256 "5af004e182ac7214dadf34816086d0a25c7a6cac568ae3741fca527cbbd242fc"
  end

  def install
    system ENV.cc, "-o", "tools/qt-faststart", "tools/qt-faststart.c"
    bin.install "tools/qt-faststart"
  end

  test do
    input = "H264_test4_Talkingheadclipped_mov_480x320.mov"
    output = "out.mov"
    resource("mov").stage testpath
    system "#{bin}/qt-faststart", input, output

    assert File.exist? output
  end
end
