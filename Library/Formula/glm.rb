require 'formula'

class Glm < Formula
  homepage 'http://glm.g-truc.net/'
  url 'http://downloads.sourceforge.net/project/ogl-math/glm-0.9.4.5/glm-0.9.4.5.zip'
  sha1 '034ff832393633211c23d3805392e426604184fb'
  head 'https://github.com/Groovounet/glm.git'

  def install
    include.install 'glm'
  end
end
