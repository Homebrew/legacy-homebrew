require 'formula'

class Autoenv < Formula
  desc "Per-project, per-directory shell environments"
  homepage 'https://github.com/kennethreitz/autoenv'
  url 'https://github.com/kennethreitz/autoenv/archive/c4bc3f5093f73e5c23563aa5cd66307e2804f35d.tar.gz'
  sha256 'dc9df7c4446e30e5fb93a7ea837d1387e9810c4b78ffc566eab4ca062253aa65'
  version '1.0.0'

  head 'https://github.com/kennethreitz/autoenv.git'

  def install
    prefix.install "activate.sh"
  end

  def caveats; <<-EOS.undent
    To finish the installation, source activate.sh in your shell:
      source #{opt_prefix}/activate.sh
    EOS
  end
end
