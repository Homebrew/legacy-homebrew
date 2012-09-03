require 'formula'

class Autoenv < Formula
  homepage 'https://github.com/kennethreitz/autoenv'
  url 'https://github.com/kennethreitz/autoenv/tarball/v0.1.0'
  sha1 '0682a230af78e72144dd9190ba216dada851235a'

  head 'https://github.com/kennethreitz/autoenv.git', :branch => 'master'

  def install
    prefix.install "activate.sh"
  end

  def caveats; <<-EOS.undent
      Autoenv was installed to:
       #{prefix}

      To finish the installation, source activate.sh in your shell:
          source #{prefix}/activate.sh
    EOS
  end
end
