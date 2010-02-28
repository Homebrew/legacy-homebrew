require 'formula'

class Nkf < Formula

  url 'http://heian.s3.amazonaws.com/nkf-2.1.0.tar.gz'
  homepage 'http://sourceforge.jp/projects/nkf/'
  md5 '1d3fd56ccd2f60768e59dde44ccf095c'

  def install
    ENV['prefix'] = prefix
    system 'make'
    system 'make install'
  end

  def patches
    # Makefile patch
    [ 'http://heian.s3.amazonaws.com/nkf-2.1.0.patch' ]
  end
end

