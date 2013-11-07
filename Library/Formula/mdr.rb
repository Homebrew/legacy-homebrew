require 'formula'

class Mdr < Formula
  homepage "https://github.com/halffullheart/mdr"
  url "https://github.com/halffullheart/mdr/archive/v1.0.0.zip"
  sha1 "46f9146e103b9ac8132f773ee6d7903dac066b65"

  def install
    system "rake"
    system "rake", "release"
    libexec.install Dir['release/*']
    bin.install_symlink libexec+'mdr'
  end
end
