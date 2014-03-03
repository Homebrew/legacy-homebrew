require 'formula'

class Archey < Formula
  homepage 'http://obihann.github.io/archey-osx/'
  url 'https://github.com/obihann/archey-osx/archive/1.3.tar.gz'
  sha1 '8fbc2a939d39bee1741af758d87cd54fb01472fa'

  def install
    bin.install 'bin/archey'
  end

  test do
    system "#{bin}/archey"
  end
end
