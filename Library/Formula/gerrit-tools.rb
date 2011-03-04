require 'formula'

class GerritTools <Formula
  head 'git://github.com/indirect/gerrit-tools.git'
  homepage 'https://github.com/indirect/gerrit-tools'

  def install
    prefix.install 'bin'
  end
end
