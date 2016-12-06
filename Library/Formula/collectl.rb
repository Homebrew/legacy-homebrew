require 'formula'

class Collectl < Formula
  homepage 'http://collectl.sourceforge.net/'
  # Currently stored in my personal Dropbox folder. I'm working with the collectl
  # source code maintainer to find a more permanent home for this tarball.
  url 'https://dl.dropbox.com/u/870088/code/collectl-3.6.3.src.tar.gz'
  sha1 'ade2cef0444888739e800dfe12dade91c384e9c0'

  def install
    system "./INSTALL \"#{prefix}\" homebrew"
  end

  def test
  	# Conveniently the --help option fails if collectl can't find all the plugins and
  	# configuration files it requires to operate properly.
    system "collectl --help"
  end
end
