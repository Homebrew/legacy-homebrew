require 'formula'

class Jq < Formula
  homepage 'http://stedolan.github.com/jq/'
  url 'https://github.com/stedolan/jq/tarball/a05904b2267d53f9a305d010facd6f307a9d5373'
  version 1.2
  sha1 '816c4926966b702bf5bd57789dbee89a16532b82'
  head 'https://github.com/stedolan/jq.git'

  depends_on 'bison'

  def install
    system "make"
    bin.install 'jq'
  end
end
