class SvtplayDl < Formula
  desc "Download videos from http://svtplay.se"
  homepage "https://github.com/spaam/svtplay-dl"
  url "https://github.com/spaam/svtplay-dl/archive/0.10.2015.05.24.tar.gz"
  sha256 "2796bc95b8b8839831696356f0fa09e961e32a0765f97db16e7ce187876ae231"

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
