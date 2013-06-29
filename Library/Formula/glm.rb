require 'formula'

class Glm < Formula
  homepage 'http://glm.g-truc.net/'
  url 'http://sourceforge.net/projects/ogl-math/files/glm-0.9.4.3/glm-0.9.4.3.zip'
  sha1 '229f0ac8c9148ade0d466943efc18cdad53d14db'
  head 'https://github.com/Groovounet/glm.git'

  def install
    include.install 'glm'
  end
end
