require 'formula'

class V < Formula
  homepage 'https://github.com/rupa/v'
  head 'https://github.com/rupa/v.git'
  url 'https://github.com/rupa/v/archive/v1.0.tar.gz'
  sha1 '9e8ce44167a97c10ab41b8fc0e5ec1b2d1cbc4f3'

  def install
    bin.install 'v'
    man1.install 'v.1'
  end
end
