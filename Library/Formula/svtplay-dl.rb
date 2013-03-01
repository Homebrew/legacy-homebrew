require 'formula'

class SvtplayDl < Formula
  homepage 'https://github.com/spaam/svtplay-dl'
  url 'https://github.com/spaam/svtplay-dl/archive/0.9.2013.02.22.tar.gz'
  sha1 'aa19ba16dc110cabd7e61753ad20c2a8f751e740'

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
