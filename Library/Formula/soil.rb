require 'formula'

class Soil <Formula
  url 'http://www.lonesock.net/files/soil.zip'
  homepage 'http://www.lonesock.net/soil.html'
  md5 '4736ac4f34fd9a41fa0197eac23bbc24'
  version '2008.7'

  def install
    Dir.mkdir "projects/makefile/obj"
    Dir.mkdir "#{prefix}/include"
    lib.mkpath
    
    system "make -C projects/makefile install LOCAL=#{prefix}"
  end
end
