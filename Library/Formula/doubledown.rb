require 'formula'

class Doubledown < Formula
  desc "Sync local changes to a remote directory"
  homepage 'https://github.com/devstructure/doubledown'
  url 'https://github.com/devstructure/doubledown/archive/v0.0.2.tar.gz'
  sha1 '533587be081d6222a389d30434c3229e8c46436b'

  head 'https://github.com/devstructure/doubledown.git'

  def install
    bin.install Dir['bin/*']
    man1.install Dir['man/man1/*.1']
  end
end
