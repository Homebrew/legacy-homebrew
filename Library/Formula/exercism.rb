require 'formula'

class Exercism < Formula
  homepage 'http://exercism.io/'

  case MacOS.preferred_arch.to_sym
  when Hardware::CPU.arch_64_bit
    version  '1.3.0-64bit'
    sha1 'c2eb7b3973f15b2be4a067cbe2d97d5aa7732920'
    url 'https://github.com/exercism/cli/releases/download/v1.3.0/exercism-darwin-amd64.tgz'
  when Hardware::CPU.arch_32_bit
    version  '1.3.0-32bit'
    sha1 '531b95eed6d386d02b69de2660861e15ed8994f2'
    url 'https://github.com/exercism/cli/releases/download/v1.3.0/exercism-darwin-386.tgz'
  else
    puts "\n"
    onoe "The preferred architecture is neither 32 or 64bit. It is #{MacOS.preferred_arch}"
    exit 1
  end

  def install
    bin.install "exercism"
  end

  test do
    assert_equal 'exercism version 1.3.0', `#{bin}/exercism --version`.strip
  end
end
