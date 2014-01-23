require 'formula'

class Logentries < Formula
  homepage 'https://logentries.com/doc/agent/'
  url 'https://github.com/logentries/le/archive/v1.2.16.tar.gz'
  sha1 'cdb0ea98e4e2654820d6810c690d330613cd285d'

  conflicts_with 'le', :because => 'both install a le binary'

  def install
    bin.install 'le'
  end
end
