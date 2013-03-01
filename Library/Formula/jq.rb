require 'formula'

class Jq < Formula
  homepage 'http://stedolan.github.com/jq/'
  url 'https://github.com/stedolan/jq/archive/jq-1.2.tar.gz'
  sha1 'cdc57153a8105d9918cb84dff183cca8aa36f6de'

  head 'https://github.com/stedolan/jq.git'

  depends_on 'bison'

  def install
    system "make"
    bin.install 'jq'
  end
end
