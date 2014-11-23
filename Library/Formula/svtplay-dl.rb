require "formula"

class SvtplayDl < Formula
  homepage "https://github.com/spaam/svtplay-dl"
  url "https://github.com/spaam/svtplay-dl/archive/0.9.2014.11.16.tar.gz"
  sha1 "46405160291d4734fe5ee33fbda1b3a205340e15"

  depends_on "rtmpdump"

  def install
    bin.install "svtplay-dl"
  end

  def caveats; <<-EOS.undent
    You need PyCrypto (https://www.dlitz.net/software/pycrypto/) to download
    encrypted HLS streams.
    You need PyAMF (http://www.pyamf.org/) for kanal5play.se.
    EOS
  end
end
