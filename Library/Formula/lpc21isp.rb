require 'formula'

class Lpc21isp < Formula
  url 'http://sourceforge.net/projects/lpc21isp/files/lpc21isp/1.79/lpc21isp_179.zip'
  version '1.79'
  homepage 'http://lpc21isp.sourceforge.net/'
  md5 '67c1e2a4cebccadd6fb8ea39faf8c89e'

  def install
    system "make"
    bin.install ["lpc21isp"]
  end
end
