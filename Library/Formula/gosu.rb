require 'formula'

class Gosu < Formula
  homepage 'http://gosu-lang.org/'
  url 'http://gosu-lang.org/nexus/content/repositories/gosu/org/gosu-lang/gosu/gosu/0.10.1/gosu-0.10.1-full.tar.gz'
  sha1 'c2e2197cc67e74d6de2076a5c859fcae7156af0b'

  def install
    rm "bin/gosu.cmd"
    touch "ext/.anchor"
    prefix.install Dir['*']
  end
end
