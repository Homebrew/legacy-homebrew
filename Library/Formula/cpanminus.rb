require 'formula'

class Cpanminus < Formula
  head 'https://github.com/miyagawa/cpanminus.git'
  homepage 'https://github.com/miyagawa/cpanminus'

  def install
    bin.install ['cpanm']
  end
end
