require 'formula'

class Aoeui < Formula
  homepage 'http://aoeui.googlecode.com/'
  url 'http://aoeui.googlecode.com/files/aoeui-1.6.tgz'
  sha1 '6dd4949b844cad1f1380b1f218088c7b385f589f'
  head 'http://aoeui.googlecode.com/svn/trunk/'

  def install
    system "make", "INST_DIR=#{prefix}", "install"
  end
end
