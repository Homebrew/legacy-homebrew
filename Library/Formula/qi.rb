require 'formula'

class Qi < Formula
  homepage 'http://www.lambdassociates.org/'
  url 'http://www.lambdassociates.org/Download/QiII1.07.zip'
  sha1 '9170e2667902ada04bae3bf494b9560bc3d58fee'

  option 'SBCL', 'Use SBCL instead of CLISP'

  if build.include? 'SBCL'
    depends_on 'sbcl'
  else
    depends_on 'clisp'
  end

  def install
    if build.include? 'SBCL'
      cd 'Lisp' do
        system "sbcl", "--load", "install.lsp"
      end

      system "echo \"#!/bin/bash\nsbcl --core #{prefix}/Qi.core $*\" > qi"
      prefix.install 'Lisp/Qi.core'
    else
      cd 'Lisp' do
        system "clisp", "install.lsp"
      end

      system "echo \"#!/bin/bash\nclisp -M #{prefix}/Qi.mem $*\" > qi"
      prefix.install 'Lisp/Qi.mem'
    end
    system "chmod 755 qi"
    bin.install ['qi']
  end
end
