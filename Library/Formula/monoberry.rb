require 'formula'

class Monoberry < Formula
  homepage 'http://burningsoda.com/software/monoberry/'
  url 'https://github.com/roblillack/monoberry/releases/download/0.1.0/monoberry-0.1.0.tgz'
  sha1 '733598dd918afd0f34947e9b0db66d25f9f4619e'

  def install
    mkdir_p "#{share}/monoberry"
    mkdir_p "#{bin}"
    cp_r ["target/lib", "target/target", "target/tool"], "#{share}/monoberry"
    File.open("#{bin}/monoberry", 'w') { |file|
      file.write("#!/bin/sh\nmono #{share}/monoberry/tool/monoberry.exe $@\n")
    }
    chmod 0755, "#{bin}/monoberry"
  end
end
