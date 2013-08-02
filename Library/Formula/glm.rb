require 'formula'

class Glm < Formula
  homepage 'http://glm.g-truc.net/'
  url 'http://downloads.sourceforge.net/project/ogl-math/glm-0.9.4.4/glm-0.9.4.4.zip'
  sha1 'a4f24a9721caf50791c75b740fa2474f95b6c228'
  head 'https://github.com/Groovounet/glm.git'

  def install
    include.install 'glm'
  end
end
