require 'formula'

class Glm < Formula
  homepage 'http://glm.g-truc.net/'
  url 'https://sourceforge.net/projects/ogl-math/files/glm-0.9.3.4/glm-0.9.3.4.zip'
  sha1 '1ce94772251e680079254c149954e7d2124630d2'
  head 'https://github.com/Groovounet/glm.git'

  def install
    include.install 'glm'
  end
end
