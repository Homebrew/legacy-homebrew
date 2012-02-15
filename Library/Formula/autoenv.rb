require 'formula'

class Autoenv < Formula
  homepage 'https://github.com/kennethreitz/autoenv'
  url 'https://github.com/kennethreitz/autoenv.git', :tag => 'v0.0.1'
  version '0.0.1'

  head 'https://github.com/kennethreitz/autoenv.git', :branch => 'master'

  def install
    system "cp", "activate.sh", "#{prefix}"
  end

  def caveats
    caveats = <<-EOS.undent
      Autoenv was installed to:
       #{prefix}

      To finish the installation, source activate.sh in your shell:

          source #{prefix}/activate.sh

      Here's a shortcut:

          echo 'source #{prefix}/activate.sh' >> ~/.bashrc

    EOS

    return caveats
  end

end
