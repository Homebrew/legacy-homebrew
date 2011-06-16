require 'formula'

class Cast < Formula
  url 'http://files.cast-project.org/cast-0.1.0.tar.gz'
  homepage 'http://cast-project.org'
  md5 'b8419063c0f15a50a36b7525345d91b9'

  depends_on 'node.js'
  depends_on 'runit'
  depends_on 'scons'

  def install
    system "scons", "install", "CASTPREFIX=#{prefix}"
  end
end
