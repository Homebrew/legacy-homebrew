require 'formula'

class Monoberry < Formula
  homepage 'http://burningsoda.com/software/monoberry/'
  url 'https://github.com/roblillack/monoberry/releases/download/0.1.0/monoberry-0.1.0.tgz'
  sha1 '733598dd918afd0f34947e9b0db66d25f9f4619e'

  def install
    (share/'monoberry').install "target/lib", "target/target", "target/tool"
    (bin/'monoberry').write <<-EOS
#!/bin/sh
mono #{share}/monoberry/tool/monoberry.exe "$@"
    EOS
  end
end
