require "formula"

class Glew < Formula
  homepage "http://glew.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/glew/glew/1.11.0/glew-1.11.0.tgz"
  sha1 "9bb5c87c055acd122a4956112bbb18ee72c38e5c"

  bottle do
    cellar :any
    sha1 "45a06a30935d2c707f389da25ba45e1169801480" => :mavericks
    sha1 "01928578947d9c3d98ae2ec78e43aec837854a0a" => :mountain_lion
    sha1 "d7c6a1a25c3d55230be4c977ebb6774840926d3a" => :lion
  end

  def install
    # Makefile directory race condition on lion
    ENV.deparallelize

    inreplace "glew.pc.in", "Requires: @requireslib@", ""
    system "make", "GLEW_DEST=#{prefix}", "all"
    system "make", "GLEW_DEST=#{prefix}", "install.all"
  end
end
