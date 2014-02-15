require 'formula'

class Glm < Formula
  homepage 'http://glm.g-truc.net/'
  url 'http://downloads.sourceforge.net/project/ogl-math/glm-0.9.5.2/glm-0.9.5.2.zip'
  sha1 '647736ff89bde9543ce20c1a4497674f9fbf6ab9'
  head 'https://github.com/Groovounet/glm.git'

  def install
    include.install 'glm'
  end
end
