require 'formula'

class Jq < Formula
  homepage 'http://stedolan.github.com/jq/'
  url 'https://nodeload.github.com/stedolan/jq/tar.gz/jq-1.2'
  sha1 'cdc57153a8105d9918cb84dff183cca8aa36f6de'
  head 'https://github.com/stedolan/jq.git'

  def install
    system "make"
    bin.install 'jq'
  end
end
