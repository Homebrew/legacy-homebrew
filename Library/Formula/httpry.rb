require 'formula'

class Httpry < Formula
  homepage 'http://dumpsterventures.com/jason/httpry/'
  url 'http://dumpsterventures.com/jason/httpry/httpry-0.1.5.tar.gz'
  sha1 'b9c5b117502c8e52fa19812f5e26cc0d82afde3d'

  depends_on :bsdmake

  def install
    system "bsdmake"
    bin.install 'httpry'
    man1.install 'httpry.1'
  end
end
