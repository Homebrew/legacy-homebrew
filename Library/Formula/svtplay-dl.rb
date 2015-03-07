require "formula"

class SvtplayDl < Formula
  homepage "https://github.com/spaam/svtplay-dl"
  url "https://github.com/spaam/svtplay-dl/archive/0.10.2015.01.28.tar.gz"
  sha1 "13dd5d05c5cd7b0166c74df434b88d28885ec4c4"

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
