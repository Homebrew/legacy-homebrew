require 'formula'

class Jsonpp < Formula
  homepage 'http://jmhodges.github.io/jsonpp/'
  url 'https://github.com/jmhodges/jsonpp/releases/v1.2.0/715/jsonpp-1.2.0-osx-x86_64.zip'
  version '1.2.0'
  sha1 '422d5b2cefa92923d2fbef9afe1324d72134509e'

  def install
    bin.install 'jsonpp'
  end
end
