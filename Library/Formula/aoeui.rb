require 'formula'

class Aoeui <Formula
  url 'http://aoeui.googlecode.com/files/aoeui-1.4.tgz'
  head 'http://aoeui.googlecode.com/svn/trunk/'
  homepage 'http://aoeui.googlecode.com/'
  md5 '8df4615fdf854838fe6c8ca773d0a6ea'

  def install
    system "make", "INST_DIR=#{prefix}", "install"
  end
end
