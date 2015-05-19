require "formula"

class SvtplayDl < Formula
  desc "Download videos from http://svtplay.se"
  homepage "https://github.com/spaam/svtplay-dl"
  url "https://github.com/spaam/svtplay-dl/archive/0.10.2015.05.24.tar.gz"
  sha1 "760a6459842ec66dfdc47c13dca7a4892ea6db56"

  depends_on "rtmpdump"

  def install
    bin.install "svtplay-dl"
  end

  def caveats; <<-EOS.undent
    You need PyCrypto (https://www.dlitz.net/software/pycrypto/) to download
    encrypted HLS streams.
    EOS
  end
end
