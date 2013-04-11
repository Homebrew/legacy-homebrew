require 'formula'

class SvtplayDl < Formula
  homepage 'https://github.com/spaam/svtplay-dl'
  url 'https://github.com/spaam/svtplay-dl/archive/0.9.2013.03.06.tar.gz'
  sha1 '172675fe5120e4191cbec4bef4e6d3a66f555a56'

  depends_on 'rtmpdump'

  def install
    bin.install 'svtplay_dl.py' => "svtplay-dl"
  end

  def caveats; <<-EOS.undent
    You need PyCrypto (https://www.dlitz.net/software/pycrypto/) to
    download encrypted HLS streams.
    You need PyAMF (http://www.pyamf.org/) for kanal5play.se.
    EOS
  end
end
