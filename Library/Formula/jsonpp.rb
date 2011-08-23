require 'formula'

class Jsonpp < Formula
  url 'http://github.com/jmhodges/jsonpp/downloads/jsonpp-1.0.0-osx-x86_64.zip'
  homepage 'http://jmhodges.github.com/jsonpp/'
  md5 '2cd5faf6f11466b587a4ab744de13a16'

  def install
    bin.install "jsonpp"
  end
end
