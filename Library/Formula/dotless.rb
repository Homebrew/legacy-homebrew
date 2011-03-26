require 'formula'

class Dotless < Formula
  homepage "http://www.dotlesscss.org/"
  url "https://github.com/downloads/dotless/dotless/dotless-v1.1.0.7a.zip"
  md5 "1dcca3961124619b01a2d590e7e08998"
  version "1.1.0.7a"

  # Head version is in GitHub, but requires builds:
  # https://github.com/dotless/dotless

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
