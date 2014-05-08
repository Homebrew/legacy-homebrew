require "formula"

class Betty < Formula
  homepage "https://github.com/pickhardt/betty"
  url "https://github.com/pickhardt/betty.git"
  sha1 "fed0e108d9a9ceb059428a3601c163d939c80bbc"
  version "0.1.3"

  def install
    prefix.install 'lib', 'main.rb'
    (bin/'betty').write <<-EOS.undent
      #!/usr/bin/env bash
      #{prefix/'main.rb'} $@
    EOS
  end

  test do
    system bin/'betty'
  end
end
