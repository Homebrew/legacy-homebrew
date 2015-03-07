require "formula"

class Glew < Formula
  homepage "http://glew.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/glew/glew/1.11.0/glew-1.11.0.tgz"
  sha1 "9bb5c87c055acd122a4956112bbb18ee72c38e5c"

  bottle do
    cellar :any
    revision 2
    sha1 "0f140259d5cb5525153b32102220432fefba1bee" => :yosemite
    sha1 "ab31a942adaf43f20cea1fd39d1a04949615c2de" => :mavericks
    sha1 "0ea8a4b4ec385c39eb52732ce8527f68410e35da" => :mountain_lion
  end

  option :universal

  def install
    # Makefile directory race condition on lion
    ENV.deparallelize

    if build.universal?
      ENV.universal_binary

      # Do not strip resulting binaries; https://sourceforge.net/p/glew/bugs/259/
      ENV["STRIP"] = ""
    end

    inreplace "glew.pc.in", "Requires: @requireslib@", ""
    system "make", "GLEW_PREFIX=#{prefix}", "GLEW_DEST=#{prefix}", "all"
    system "make", "GLEW_PREFIX=#{prefix}", "GLEW_DEST=#{prefix}", "install.all"
  end
end
