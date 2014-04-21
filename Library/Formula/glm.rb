require 'formula'

class Glm < Formula
  homepage 'http://glm.g-truc.net/'
  url 'https://downloads.sourceforge.net/project/ogl-math/glm-0.9.5.3/glm-0.9.5.3.zip'
  sha1 'e5035b496390b0f05afc823f3930186139c9b2bf'
  head 'https://github.com/Groovounet/glm.git'

  def install
    include.install 'glm'
  end
end
