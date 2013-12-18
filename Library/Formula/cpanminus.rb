require 'formula'

class Cpanminus < Formula
  homepage 'https://github.com/miyagawa/cpanminus'
  url 'https://github.com/miyagawa/cpanminus/archive/1.7102.tar.gz'
  sha1 '2dce39eba39b226e20bfd178c3502fc9699f973b'

  head 'https://github.com/miyagawa/cpanminus.git'

  def install
    bin.install 'cpanm'
  end
end
