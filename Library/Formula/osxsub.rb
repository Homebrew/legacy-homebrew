require 'formula'

class Osxsub < Formula
  homepage 'https://github.com/mwunsch/osxsub'
  url 'https://github.com/mwunsch/osxsub/tarball/v0.1.2'
  sha1 '93c766bfde5aa27c186018d4450c0c41ddae6ffa'
  head 'https://github.com/mwunsch/osxsub.git'

  def install
    bin.install 'bin/osxsub'
    prefix.install 'lib'
  end
end