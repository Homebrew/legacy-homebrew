require 'formula'

class Kzipmix < Formula
  url 'http://static.jonof.id.au/dl/kenutils/kzipmix-20091108-darwin.tar.gz'
  homepage 'http://www.advsys.net/ken/utils.htm'
  md5 '2047c3b1998d2ea3600ba587ea909093'
  version '20091108'

  def install
    bin.install ['kzip', 'zipmix']
  end
end
