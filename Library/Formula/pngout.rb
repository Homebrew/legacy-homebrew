require 'formula'

class Pngout < Formula
  url 'http://static.jonof.id.au/dl/kenutils/pngout-20110109-darwin.tar.gz'
  homepage 'http://www.advsys.net/ken/util/pngout.htm'
  md5 '86d1215e35a6af62cf80314ea1ad3b91'
  version '20110109'

  def install
    bin.install 'pngout'
  end
end
