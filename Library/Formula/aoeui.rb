require 'formula'

class Aoeui < Formula
  url 'http://aoeui.googlecode.com/files/aoeui-1.5.tgz'
  sha1 'f0368cf55ab75cc359d8b6f55928bbeac3aecaa0'
  head 'http://aoeui.googlecode.com/svn/trunk/'
  homepage 'http://aoeui.googlecode.com/'

  def install
    system "make", "INST_DIR=#{prefix}", "install"
  end
end
