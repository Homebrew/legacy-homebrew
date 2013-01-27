require 'formula'

class Doubledown < Formula
  homepage 'https://github.com/devstructure/doubledown'
  url 'https://github.com/devstructure/doubledown/tarball/v0.0.2'
  sha1 '518d9df0457b6ce464679f8db4c7f692c7c72a9f'

  head 'https://github.com/devstructure/doubledown.git'

  def install
    bin.install Dir['bin/*']
    man1.install Dir['man/man1/*.1']
  end
end
