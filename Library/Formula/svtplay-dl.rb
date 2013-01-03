require 'formula'

class SvtplayDl < Formula
  homepage 'https://github.com/spaam/svtplay-dl'
  url 'https://github.com/spaam/svtplay-dl/archive/0.8.2012.12.30.tar.gz'
  sha1 '0ce48fe7a43419243e1bd20c7c65d1cece00b478'

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
