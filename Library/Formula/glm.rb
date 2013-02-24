require 'formula'

class Glm < Formula
  homepage 'http://glm.g-truc.net/'
  url 'http://sourceforge.net/projects/ogl-math/files/glm-0.9.4.2/glm-0.9.4.2.zip'
  sha1 '274044cd5c45fd0f2b013d8b4d4e799d0f171b01'
  head 'https://github.com/Groovounet/glm.git'

  def install
    include.install 'glm'
  end
end
