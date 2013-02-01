require 'formula'

class SvtplayDl < Formula
  homepage 'https://github.com/spaam/svtplay-dl'
  url 'https://github.com/spaam/svtplay-dl/archive/0.8.2013.01.18.tar.gz'
  sha1 '8d2aee7517f462cdef4255021fae3a52a019bd86'

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
