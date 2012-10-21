require 'formula'

class Cpanminus < Formula
  homepage 'https://github.com/miyagawa/cpanminus'
  url 'https://github.com/miyagawa/cpanminus/tarball/1.5018'
  sha1 'e39120f65d8983990661200457925775c2259d5c'

  head 'https://github.com/miyagawa/cpanminus.git'

  def install
    bin.install 'cpanm'
  end
end
