require 'formula'

class Darcs <Formula
  url 'http://garrettbarboza.com/darcs-2.5-OSX.tar.gz'
  homepage 'http://darcs.net/'
  md5 '7f9cfbf4f91da6b45e600e80d6c979b7'
  version '2.5'

  def install
    bin.install 'darcs'
  end
end
