require 'formula'

class Cast < Formula
  homepage 'http://cast-project.org'
  url 'http://files.cast-project.org/cast-0.2.0.tar.gz'
  sha1 'ab5e21c69dd0d5d1dc37b2f7d0ba7c52dddce400'

  depends_on 'scons' => :build
  depends_on 'runit'

  def install
    system "scons", "install", "CASTPREFIX=#{prefix}"
  end
end
