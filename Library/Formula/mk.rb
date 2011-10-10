require 'formula'

class Mk < Formula
  url 'http://www.crufty.net/ftp/pub/sjg/mk-20111001.tar.gz'
  homepage 'http://www.crufty.net/help/sjg/bmake.html'
  md5 'f608b630a4ad6bd5e42e5c787bca8b53'

  def install
      (share/'mk').install Dir['*']
  end
end
