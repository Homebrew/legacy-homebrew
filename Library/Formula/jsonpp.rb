require 'formula'

class Jsonpp < Formula
  homepage 'http://jmhodges.github.io/jsonpp/'
  url 'https://github.com/jmhodges/jsonpp/releases/v1.2.0/715/jsonpp-1.2.0-osx-x86_64.zip'
  version '1.2.0'
  sha1 '7aec425f3604d8c8e20f597d13df5bc5d9044a5f'

  def install
    bin.install 'jsonpp'
  end
end
