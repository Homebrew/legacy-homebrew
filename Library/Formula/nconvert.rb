require 'formula'

class Nconvert < Formula
  homepage 'http://www.xnview.com/en/nconvert.html'
  url 'http://download.xnview.com/NConvert-macosx.tgz'
  sha1 '11b09a62c1c7f3feeb53718e46a70652074e077b'

  version '6.17'
  
  def install
    bin.install 'nconvert'
  end
end
