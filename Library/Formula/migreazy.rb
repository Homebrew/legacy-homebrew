require 'formula'

class Migreazy <Formula
  head 'git://github.com/fhwang/migreazy.git'
  homepage 'http://github.com/fhwang/migreazy'

  def install
    mv 'MIT-LICENSE', 'LICENSE'
    bin.install 'bin/migreazy'
  end
end
