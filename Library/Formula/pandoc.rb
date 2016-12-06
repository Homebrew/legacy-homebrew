require 'formula'

class Pandoc < Formula
  homepage 'http://johnmacfarlane.net/pandoc/index.html'

  depends_on 'cabal-install'

  def install
    system 'cabal update'
    system 'cabal install pandoc'
  end

  def caveats
    <<-EOS.undent
      For PDF output, you'll also need LaTeX. We recommend installing BasicTeX
      and using the tlmgr tool to install additional packages as needed:

          http://www.tug.org/mactex/morepackages.html
    EOS
  end
end
