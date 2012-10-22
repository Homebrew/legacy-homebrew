require 'formula'

class Jsonpp < Formula
  url 'http://cloud.github.com/downloads/jmhodges/jsonpp/jsonpp-1.0.0-osx-x86_64.zip'
  homepage 'http://jmhodges.github.com/jsonpp/'
  sha1 'fecba52fda2a9e08f23ea76b5c53d1d6c894f564'

  def install
    bin.install 'jsonpp'
  end
end
