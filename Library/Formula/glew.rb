require "formula"

class Glew < Formula
  homepage "http://glew.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/glew/glew/1.11.0/glew-1.11.0.tgz"
  sha1 "9bb5c87c055acd122a4956112bbb18ee72c38e5c"

  bottle do
    cellar :any
    sha1 "bf2cd460915846eb8d3cdc5e8d7aa3e30aeffe62" => :mavericks
    sha1 "f43f1961b8baf46d3e22364dbec3de1e42e43846" => :mountain_lion
    sha1 "482bc295f55ce52c9397c86b2e8d50940c4c5efc" => :lion
  end

  def install
    # Makefile directory race condition on lion
    ENV.deparallelize

    inreplace "glew.pc.in", "Requires: @requireslib@", ""
    system "make", "GLEW_DEST=#{prefix}", "all"
    system "make", "GLEW_DEST=#{prefix}", "install.all"
  end
end
