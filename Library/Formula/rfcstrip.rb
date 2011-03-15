require 'formula'

class Rfcstrip < Formula
  url 'http://trac.tools.ietf.org/tools/rfcstrip/rfcstrip-1.03.tgz'
  homepage 'http://trac.tools.ietf.org/tools/rfcstrip/'
  md5 '8b1a1e8b2a7e893428deb04a8e981c7d'

  def install
    bin.install "rfcstrip"
    doc.install %w(about todo)
  end
end
