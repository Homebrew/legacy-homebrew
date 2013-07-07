require 'formula'

class Jsl < Formula
  homepage 'http://www.javascriptlint.com/'
  url 'http://www.javascriptlint.com/download/jsl-0.3.0-mac.tar.gz'
  sha1 'a6dd106a05ee81130a27a49d29233afeb8796ab0'

  def install
    bin.install 'jsl'
  end
end
