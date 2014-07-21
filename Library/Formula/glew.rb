require 'formula'

class Glew < Formula
  homepage 'http://glew.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/glew/glew/1.10.0/glew-1.10.0.tgz'
  sha1 'f41b45ca4a630ad1d00b8b87c5f493781a380300'

  bottle do
    cellar :any
    sha1 "bf2cd460915846eb8d3cdc5e8d7aa3e30aeffe62" => :mavericks
    sha1 "f43f1961b8baf46d3e22364dbec3de1e42e43846" => :mountain_lion
    sha1 "482bc295f55ce52c9397c86b2e8d50940c4c5efc" => :lion
  end

  def install
    inreplace "glew.pc.in", "Requires: glu", ""
    system "make", "GLEW_DEST=#{prefix}", "all"
    system "make", "GLEW_DEST=#{prefix}", "install.all"
  end
end
