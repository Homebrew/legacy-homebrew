require "formula"

class Glm < Formula
  homepage "http://glm.g-truc.net/"
  url "https://downloads.sourceforge.net/project/ogl-math/glm-0.9.6.1/glm-0.9.6.1.zip"
  sha1 "9ce9ee54eebed923416ae8269e7afb9aa7e75b46"
  head "https://github.com/g-truc/glm.git"

  def install
    include.install "glm"
  end
end
