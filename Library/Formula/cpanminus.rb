require 'formula'

class Cpanminus < Formula
  url 'https://github.com/miyagawa/cpanminus/tarball/1.5007'
  sha1 'd0bbf766a7250253138381833af152895f8115b7'
  head 'https://github.com/miyagawa/cpanminus.git'
  homepage 'https://github.com/miyagawa/cpanminus'

  def install
    bin.install ['cpanm']
  end
end
