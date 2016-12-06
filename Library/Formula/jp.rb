require 'formula'

class Jp < Formula
  version '0.1'
  homepage 'http://www.paulhammond.org/jp/'
  url 'http://www.paulhammond.org/jp/jp-0.1-mac.tgz'
  sha1 '5495c61cbe250ea0e56ba795f37e5d04a506609a'

  def install
    bin.install 'jp'
  end

  test do
    system 'jp'
  end
end
