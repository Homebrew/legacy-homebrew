require 'formula'

class Ssht < Formula
  homepage 'https://github.com/brejoc/ssht/'
  url 'https://github.com/brejoc/ssht/archive/0.3.tar.gz'
  sha1 'bcfde2a7c90fbe88e111cb45c18ebd800e60477f'

  head 'https://github.com/brejoc/ssht.git', :revision => '4783d77f6db4035100f695f904e8ec0a20021a9c'

  def install
    bin.install "ssht"
  end
end
