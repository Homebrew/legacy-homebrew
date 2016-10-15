require "formula"

class HydraCli < Formula
  homepage 'https://github.com/sdegutis/hydra-cli'
  url 'https://github.com/sdegutis/hydra-cli/archive/v1.0.tar.gz'
  sha256 '77526353fbc22a4dab87a4a90a76a3d73f1df4327256476d9747faed630d9189'

  head 'https://github.com/sdegutis/hydra-cli.git'

  def install
    system "make"
    bin.install 'hydra'
    man1.install 'hydra.1'
  end

end
