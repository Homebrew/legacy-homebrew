require 'formula'

class Glm < Formula
  homepage 'http://glm.g-truc.net/'
  url 'http://downloads.sourceforge.net/project/ogl-math/glm-0.9.4.6/glm-0.9.4.6.zip'
  sha1 'a909c34c718e9146575717d429ee55647b692d41'
  head 'https://github.com/Groovounet/glm.git'

  def install
    include.install 'glm'
  end
end
