require 'formula'

class Pit < Formula
  url 'https://github.com/michaeldv/pit/tarball/0.1.0'
  homepage 'http://github.com/michaeldv/pit'
  md5 '981d6a9f781c3cfeee0349468e2cab7f'

  def install
    system "make"
    bin.install "bin/pit"
  end
end
