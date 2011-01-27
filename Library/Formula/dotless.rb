require 'formula'

class Dotless < Formula
  homepage "http://www.dotlesscss.com/"
  url "http://www.dotlesscss.com:8081/repository/download/bt3/.lastPinned/dotless-v1.1.0.2-26-gd3370bd.zip?guest=1"
  md5 '7fd6e39e47aeaaae615d061bc472c32e'
  version "1.1.0.2-26"

  # Head version is in GitHub, but requires builds:
  # http://github.com/dotless/dotless

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
