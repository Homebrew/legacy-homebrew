require 'formula'

# Don't upgrade until this issue is resolved:
# https://github.com/dotless/dotless/issues/issue/22
class Dotless < Formula
  homepage "http://www.dotlesscss.org/"
  url "https://github.com/dotless/dotless/tarball/v1.1.0.3"
  md5 "6ca4801461c31214d2775858bc9adb29"
  version "1.1.0.3"

  def install
    mono_path = `/usr/bin/which mono`.strip
    if mono_path.size == 0
      opoo "mono not found in path"
      puts "You need to install Mono to run this software:"
      puts "http://www.go-mono.com/mono-downloads/download.html"
    end

    (bin + 'dotless').write <<-EOF
#!/bin/bash
exec #{mono_path} #{libexec}/dotless.Compiler.exe $@
EOF

    libexec.install Dir['*.exe']
    (share+'dotless').install Dir['*.txt']
  end
end
