require "formula"

class Glew < Formula
  homepage "http://glew.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/glew/glew/1.11.0/glew-1.11.0.tgz"
  sha1 "9bb5c87c055acd122a4956112bbb18ee72c38e5c"

  bottle do
    cellar :any
    revision 1
    sha1 "bd5a2a92acf5443149d5a7b86599b6092192f7f7" => :mavericks
    sha1 "46c52b5ee309f0b753eed917dc506c677fc11492" => :mountain_lion
    sha1 "82232dfa4c363b10f4a3f45248e9fa024851f9dd" => :lion
  end

  def install
    # Makefile directory race condition on lion
    ENV.deparallelize

    inreplace "glew.pc.in", "Requires: @requireslib@", ""
    system "make", "GLEW_PREFIX=#{prefix}", "GLEW_DEST=#{prefix}", "all"
    system "make", "GLEW_PREFIX=#{prefix}", "GLEW_DEST=#{prefix}", "install.all"
  end
end
