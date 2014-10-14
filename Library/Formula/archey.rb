require 'formula'

class Archey < Formula
  homepage 'http://obihann.github.io/archey-osx/'
  url 'https://github.com/obihann/archey-osx/archive/1.4.tar.gz'
  sha1 '545896848444cd77b0c2cad50d5477f824ecf72f'
  head 'https://github.com/obihann/archey-osx.git'

  def install
    bin.install 'bin/archey'
  end

  test do
    system "#{bin}/archey"
  end
end
