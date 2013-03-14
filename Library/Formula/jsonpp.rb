require 'formula'

class Jsonpp < Formula
  homepage 'http://jmhodges.github.com/jsonpp/'
  url 'http://projects.somethingsimilar.com/jsonpp/downloads/jsonpp-1.1.0-osx-x86_64.zip'
  version '1.1.0'
  sha1 '2392c3c1c4ff38a0a1ed59e5cb23ac633d7fb54d'

  def install
    bin.install 'jsonpp'
  end
end
