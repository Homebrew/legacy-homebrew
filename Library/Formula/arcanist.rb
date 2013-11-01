require 'formula'

class Arcanist < Formula
  homepage 'http://www.phabricator.org'
  url 'https://github.com/tobyhughes/arcanist-installer/raw/master/arcanist-1.0.tar.gz'
  sha1 'b07ea3810dee392233eb132f57ca28d5561a61b7'

  def install
    system "ruby", "arcanist.rb"
  end
end
