require 'formula'

class Gobuild <Formula
  head 'http://gobuild.googlecode.com/hg/'
  homepage 'http://code.google.com/p/gobuild/'

  depends_on 'go'

  def install
    ENV.j1 # https://github.com/mxcl/homebrew/issues/#issue/237
    system "make"
    bin.install 'gobuild'
  end
end
