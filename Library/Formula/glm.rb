require 'formula'

class Glm < Formula
  homepage 'http://glm.g-truc.net/'
  url 'https://github.com/Groovounet/glm/tarball/0.9.3.2'
  sha1 '5000ad44ee5a80612d05781d43413119b6de0872'
  head 'https://github.com/Groovounet/glm.git'

  keg_only 'GLM is a header only library.'

  def install
    include.install 'glm'
  end
end
