require 'formula'

class SvtplayDl < Formula
  homepage 'https://github.com/spaam/svtplay-dl'
  url 'https://github.com/spaam/svtplay-dl/archive/0.9.2013.10.14.tar.gz'
  sha1 'ab7017d699ae963729ff43055600ca4bca21213d'

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
