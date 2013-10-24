require 'formula'

class Logentries < Formula
  homepage 'https://logentries.com/doc/agent/'
  url 'https://github.com/logentries/le/archive/v1.2.12.tar.gz'
  sha1 '7dc003bee3c3169fc88a34aa21cdc3e606e194df'

  def install
    bin.install 'le'
  end
end
