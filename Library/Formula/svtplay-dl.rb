require 'formula'

class SvtplayDl < Formula
  homepage 'https://github.com/spaam/svtplay-dl'
  url 'https://github.com/spaam/svtplay-dl/archive/0.8.2012.12.23.tar.gz'
  sha1 'dc86f717f8c0f7aaa6fd2e94bd75fea49aa02dc6'

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
