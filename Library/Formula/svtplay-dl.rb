require 'formula'

class SvtplayDl < Formula
  homepage 'https://github.com/spaam/svtplay-dl'
  url 'https://github.com/spaam/svtplay-dl/archive/0.9.2013.12.11.tar.gz'
  sha1 'd44eee92694b0fc2af1a0ae8a35d0a2ecfb3c09f'

  depends_on 'rtmpdump'

  def install
    bin.install 'svtplay-dl'
  end

  def caveats; <<-EOS.undent
    You need PyCrypto (https://www.dlitz.net/software/pycrypto/) to
    download encrypted HLS streams.
    You need PyAMF (http://www.pyamf.org/) for kanal5play.se.
    EOS
  end
end
