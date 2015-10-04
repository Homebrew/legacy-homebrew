class SvtplayDl < Formula
  desc "Download videos from http://svtplay.se"
  homepage "https://github.com/spaam/svtplay-dl"
  url "https://github.com/spaam/svtplay-dl/archive/0.10.2015.08.24.tar.gz"
  sha256 "0dcd2c6862ad0ed00a2b782f6484f005431de3229360e1797810f7adf16aedd9"

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
