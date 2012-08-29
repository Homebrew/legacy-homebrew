require 'formula'

class Jsl < Formula
  homepage 'http://www.javascriptlint.com/'
  url 'http://www.javascriptlint.com/download/jsl-0.3.0-mac.tar.gz'
  md5 '23c1c8e70dc991d35271074723a96d5d'

  def install
    bin.install 'jsl'
  end
end
