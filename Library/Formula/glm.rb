require "formula"

class Glm < Formula
  homepage "http://glm.g-truc.net/"
  url "https://downloads.sourceforge.net/project/ogl-math/glm-0.9.5.4/glm-0.9.5.4.zip"
  sha1 "d9666b5b013d374c7d1a498c9495f7142f6fe9d3"
  head "https://github.com/Groovounet/glm.git"

  def install
    include.install "glm"
  end
end
