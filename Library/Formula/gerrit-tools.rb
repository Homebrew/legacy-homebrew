require 'formula'

class GerritTools < Formula
  head 'https://github.com/indirect/gerrit-tools.git'
  homepage 'https://github.com/indirect/gerrit-tools'

  def install
    prefix.install 'bin'
  end
end
