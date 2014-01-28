require 'formula'

class Gosu < Formula
  homepage 'http://gosu-lang.org/'
  url 'http://gosu-lang.org/nexus/content/repositories/gosu/org/gosu-lang/gosu/gosu/0.10.2/gosu-0.10.2-full.tar.gz'
  sha1 '8ca0afa29049669df2ab3f335bf6a6a05e0936f5'

  def install
    rm "bin/gosu.cmd"
    touch "ext/.anchor"
    libexec.install Dir['*']
    bin.install_symlink libexec/'bin/gosu'
  end
end
