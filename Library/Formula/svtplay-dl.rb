require 'formula'

class SvtplayDl < Formula
  homepage 'https://github.com/spaam/svtplay-dl'
  url 'https://github.com/spaam/svtplay-dl/archive/0.9.2014.02.15.tar.gz'
  sha1 '5fc82a5894ee4d24c6496b4b34db28c185f72dd2'

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
