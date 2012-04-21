require 'formula'

class Ppss < Formula
  url 'http://ppss.googlecode.com/files/ppss-2.97.tgz'
  homepage 'http://ppss.googlecode.com'
  md5 '7f5b5a53fc8d059f9c0131aca57e0651'

  def install
    bin.install "ppss"
  end
end
