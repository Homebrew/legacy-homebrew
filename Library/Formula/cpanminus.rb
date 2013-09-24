require 'formula'

class Cpanminus < Formula
  homepage 'https://github.com/miyagawa/cpanminus'
  url 'https://github.com/miyagawa/cpanminus/archive/1.7001.tar.gz'
  sha1 '805dbdf4b1c1d8e9ee9adeeca8ca86db82165db3'

  head 'https://github.com/miyagawa/cpanminus.git'

  def install
    bin.install 'cpanm'
  end
end
