require 'formula'

class Logentries < Formula
  homepage 'https://logentries.com/doc/agent/'
  url 'https://github.com/logentries/le/archive/v1.3.0.tar.gz'
  sha1 '3d32c8c6a8faf9346558974310787c0dd9c3f468'

  conflicts_with 'le', :because => 'both install a le binary'

  def install
    bin.install 'le'
  end
end
