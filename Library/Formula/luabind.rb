require 'formula'

class Luabind <Formula
  head 'http://svn.kervala.net/utils/packaging/luabind', :using => :svn
  homepage 'http://www.rasterbar.com/products/luabind.html'

  depends_on 'lua'
  depends_on 'boost'

  def install
    system "mkdir build; cd build; cmake .. #{std_cmake_parameters}"
    system "make -C build/ install"
  end
end