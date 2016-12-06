require 'formula'

class Texapp < Formula
  homepage 'http://www.floodgap.com/software/texapp/'
  url 'http://www.floodgap.com/software/texapp/texapp.txt'
  sha1 'e108f416973ada515e6d0cc4c88bdfb1cec0be11'
  version '0.4.4'

  def install
    bin.install 'texapp.txt'
    mv "#{bin}/texapp.txt", "#{bin}/texapp"
  end

  test do
    `#{bin}/texapp -version`.strip =~ /#{Regexp.escape(version)}/
  end
end
