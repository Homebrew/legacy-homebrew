require 'formula'

class Glm < Formula
  homepage 'http://glm.g-truc.net/'
  url 'http://downloads.sourceforge.net/project/ogl-math/glm-0.9.5.1/glm-0.9.5.1.zip'
  sha1 'e1165e2c1be99e3cfeacbecaa15a2c89f2caf503'
  head 'https://github.com/Groovounet/glm.git'

  def install
    include.install 'glm'
  end
end
