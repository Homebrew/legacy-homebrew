require 'formula'

class AntContrib < Formula
  homepage 'http://ant-contrib.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/ant-contrib/ant-contrib/1.0b3/ant-contrib-1.0b3-bin.zip'
  sha1 '08733a1cc2e00632794084b1db52fb5a345e0999'
  version "1.0b3"

  depends_on :ant

  def install
    prefix.install 'ant-contrib-1.0b3.jar'
    ant = Formula.factory('ant')
    ant_dest = "#{ant.opt_prefix}/libexec/lib/ant-contrib.jar"
    rm_f "#{ant_dest}"
    ln_s opt_prefix/"ant-contrib-1.0b3.jar", "#{ant_dest}"
  end
end

