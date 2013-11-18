require 'formula'

class Mg < Formula
  homepage 'http://homepage.boetes.org/software/mg/'
  url 'http://homepage.boetes.org/software/mg/mg-20130922.tar.gz'
  sha1 'ddd461ebae8df3c016359956348329fd04906195'
  depends_on 'bsdmake' => :build
  depends_on 'clens'

  def patches
    { :p0 => 'https://gist.github.com/jasperla/7264123/raw'}
  end

  def install
    ENV.j1
    system "bsdmake"
    bin.install "mg"
    doc.install "tutorial"
  end
end
