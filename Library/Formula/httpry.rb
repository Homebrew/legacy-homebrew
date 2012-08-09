require 'formula'

class Httpry < Formula
  homepage 'http://dumpsterventures.com/jason/httpry/'
  url 'http://dumpsterventures.com/jason/httpry/httpry-0.1.7.tar.gz'
  sha1 '22cc6aa8079abf671b9e7f4f93b615d0b7d389d3'

  depends_on :bsdmake

  def install
    system "bsdmake"
    bin.install 'httpry'
    man1.install 'httpry.1'
  end
end
