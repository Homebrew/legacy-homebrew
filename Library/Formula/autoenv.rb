require 'formula'

class Autoenv < Formula
  homepage 'https://github.com/kennethreitz/autoenv'
  url 'https://github.com/kennethreitz/autoenv/tarball/v0.0.1'
  md5 '92dd44e136946964f6aa72967c4d032b'

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
