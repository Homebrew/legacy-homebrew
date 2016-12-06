require 'formula'

class Slv2 <Formula
  url 'http://download.drobilla.net/slv2-0.6.6.tar.bz2'
  homepage 'http://drobilla.net/software/slv2'
  md5 'b8e8e0e82dd04324fcd533e8acd1ce85'

  depends_on 'pkg-config'
  depends_on 'lv2core'
  depends_on 'redland'
  depends_on 'jack' => :optional

  def install
    system "./waf configure --prefix=#{prefix} --lv2dir=#{prefix}/share/lv2"
    system "./waf build"
    system "./waf install"
  end
end
