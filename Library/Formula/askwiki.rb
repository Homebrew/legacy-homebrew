require 'formula'

class Askwiki < Formula
  homepage 'https://github.com/bradoyler/askwiki'
  url 'https://github.com/bradoyler/askwiki/archive/0.0.1.tar.gz'
  sha1 '133d18657de36464d0e9eca6cc6289629b6928c1'
  
  depends_on :x11

  def install
    bin.install "askwiki"
    man1.install "man/askwiki.1"
  end

  test do
    system "#{bin}/askwiki", "--version"
  end
end
