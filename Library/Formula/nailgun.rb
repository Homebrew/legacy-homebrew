require 'formula'

class Nailgun <Formula
  url 'http://downloads.sourceforge.net/project/nailgun/nailgun/0.7.1/nailgun-src-0.7.1.zip'
  homepage 'http://martiansoftware.com/nailgun/index.html'
  md5 '79365e339275d774b7c5c8b17b7ece40'

  def install
    system "make"
    bin.install 'ng'
    prefix.install 'nailgun-0.7.1.jar'
  end
end
