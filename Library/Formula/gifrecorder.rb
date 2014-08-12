require "formula"

class Gifrecorder < Formula
  homepage "http://github.com/shrx/gifRecorder"

  stable do
    url "https://github.com/shrx/gifRecorder/archive/v1.4.tar.gz"
    sha1 "6f8f7d8c702ccc60fe995b71f8528fe2060d04ad"
  end

  head "https://github.com/shrx/gifRecorder"

  depends_on "gifsicle"

  def install
    bin.install "gifrecorder"
  end

  test do
    # system bin/"gifrecorder", '-h' # Returns exit code 2, so not a usable test

    assert_equal "Usage: [-s <seconds>] [-c x1,y1-x2,y2] [-w] [-v]\n", `gifrecorder -h`
  end
end
