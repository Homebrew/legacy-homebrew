require 'formula'

class Logentries < Formula
  homepage 'https://logentries.com/doc/agent/'
  url 'https://github.com/logentries/le/archive/v1.2.17.tar.gz'
  sha1 'cf961dd02a3f5df367f8435478e4362b8190b3d2'

  conflicts_with 'le', :because => 'both install a le binary'

  def install
    bin.install 'le'
  end
end
