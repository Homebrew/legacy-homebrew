require 'formula'

class Cpanminus < Formula
  homepage 'https://github.com/miyagawa/cpanminus'
  url 'https://github.com/miyagawa/cpanminus/archive/1.6923.tar.gz'
  sha1 '8be50b449a966656ccc973270a24572ebc5c3706'

  head 'https://github.com/miyagawa/cpanminus.git'

  def install
    bin.install 'cpanm'
  end
end
