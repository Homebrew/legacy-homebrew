require 'formula'

class Pandoc < Formula
  homepage 'http://johnmacfarlane.net/pandoc/index.html'
  url 'https://pandoc.googlecode.com/files/pandoc-1.11.1.tar.gz'
  sha1 '1498554ebfd18436eea401f1cb41d1075569ad03'

  def install
    system 'make install'
  end

  def caveats
    <<-EOS.undent
      For PDF output, you'll also need LaTeX. We recommend installing BasicTeX
      and using the tlmgr tool to install additional packages as needed:

          http://www.tug.org/mactex/morepackages.html
    EOS
  end
end
