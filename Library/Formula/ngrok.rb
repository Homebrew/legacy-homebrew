require 'formula'

class Ngrok < Formula
  homepage 'https://ngrok.com/'
  url 'https://github.com/inconshreveable/ngrok/archive/1.6.tar.gz'
  sha1 '03d076bfe078ebe52c0c81dfa1e49b497e7295fa'
  version '1.6'

  depends_on 'go' => :build
  depends_on 'mercurial' => :build
  depends_on 'bzr' => :build

  def install
    system "make"
    bin.install Dir['bin/*']
  end
end
