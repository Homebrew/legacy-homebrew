require 'formula'

class Ppss < Formula
  homepage 'http://ppss.googlecode.com'
  url 'http://ppss.googlecode.com/files/ppss-2.97.tgz'
  md5 '7f5b5a53fc8d059f9c0131aca57e0651'

  def install
    bin.install "ppss"
  end
end
