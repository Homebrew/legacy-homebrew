require 'formula'

class Gosu < Formula
  homepage 'http://gosu-lang.org/'
  url 'http://gosu-lang.org/nexus/content/repositories/gosu/org/gosu-lang/gosu/gosu/0.10.3/gosu-0.10.3-full.tar.gz'
  sha1 '98b94d29c2052f9def5155592eb64d7da00c7d41'

  def install
    rm "bin/gosu.cmd"
    touch "ext/.anchor"
    libexec.install Dir['*']
    bin.install_symlink libexec/'bin/gosu'
  end
end
