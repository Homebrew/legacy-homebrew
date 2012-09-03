require 'formula'

class Lpc21isp < Formula
  url 'http://sourceforge.net/projects/lpc21isp/files/lpc21isp/1.79/lpc21isp_179.zip'
  version '1.79'
  homepage 'http://lpc21isp.sourceforge.net/'
  sha1 '71e90bb67af44bdf56d58942dcc4e4fc0ff89b26'

  def install
    system "make"
    bin.install ["lpc21isp"]
  end
end
