require 'formula'

class Autoenv < Formula
  homepage 'https://github.com/kennethreitz/autoenv'
  url 'https://github.com/kennethreitz/autoenv/archive/v0.1.0.tar.gz'
  sha1 '4d773ba8162b8f49abdfc07d0f8c956aa3353e0c'

  head 'https://github.com/kennethreitz/autoenv.git', :branch => 'master'

  def install
    prefix.install "activate.sh"
  end

  def caveats; <<-EOS.undent
    Autoenv was installed to:
      #{opt_prefix}

    To finish the installation, source activate.sh in your shell:
      source #{opt_prefix}/activate.sh
    EOS
  end
end
