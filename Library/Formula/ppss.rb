require 'formula'

class Ppss < Formula
  homepage 'http://ppss.googlecode.com'
  url 'http://ppss.googlecode.com/files/ppss-2.97.tgz'
  sha1 '097dd068c16078ead8024551be6e69786f8ba533'

  def install
    bin.install "ppss"
  end
end
