require 'formula'

class Glm < Formula
  homepage 'http://glm.g-truc.net/'
  url 'https://sourceforge.net/projects/ogl-math/files/glm-0.9.4.0/glm-0.9.4.0.zip'
  sha1 '0c39e10aca7b52d37a50c5885e3330221e49c98d'
  head 'https://github.com/Groovounet/glm.git'

  def install
    include.install 'glm'
  end
end
