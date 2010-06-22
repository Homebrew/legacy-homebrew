require 'formula'

class GerritTools <Formula
  head 'git://github.com/indirect/gerrit-tools.git'
  homepage 'http://github.com/indirect/gerrit-tools'

  def install
    bin.install(Dir["bin/*"])
  end
end
