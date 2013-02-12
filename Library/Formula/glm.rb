require 'formula'

class Glm < Formula
  homepage 'http://glm.g-truc.net/'
  url 'http://sourceforge.net/projects/ogl-math/files/glm-0.9.4.1/glm-0.9.4.1.zip'
  sha1 '4fef78bf354cf75635760f405af60b43641764d6'
  head 'https://github.com/Groovounet/glm.git'

  def install
    include.install 'glm'
  end
end
