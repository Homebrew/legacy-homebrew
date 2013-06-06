require 'formula'

class Cpanminus < Formula
  homepage 'https://github.com/miyagawa/cpanminus'
  url 'https://github.com/miyagawa/cpanminus/archive/1.6915.tar.gz'
  sha1 'cab5073c8ef7f9317d0d7fac6514c1f2d568d15f'

  head 'https://github.com/miyagawa/cpanminus.git'

  def install
    bin.install 'cpanm'
  end
end
