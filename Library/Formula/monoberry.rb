require 'formula'

class Monoberry < Formula
  homepage 'http://burningsoda.com/software/monoberry/'
  url 'https://github.com/roblillack/monoberry/releases/download/0.2.0/monoberry-0.2.0.tgz'
  sha1 '223c886cc8ed79dd8e21c77760b78f659ede5b8c'

  def install
    (share/'monoberry').install "target/lib", "target/target", "target/tool"
    (bin/'monoberry').write <<-EOS
#!/bin/sh
mono #{share}/monoberry/tool/monoberry.exe "$@"
    EOS
  end
end
