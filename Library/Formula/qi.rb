require 'formula'

class Qi < Formula
  url 'http://www.lambdassociates.org/Download/QiII1.07.zip'
  homepage 'http://www.lambdassociates.org/'
  md5 '3a0b5c56d0f107f80f5bca11b82a4d59'

  def options
    [['--SBCL', 'Use SBCL instead of CLISP']]
  end

  if ARGV.include? '--SBCL'
    depends_on 'sbcl'
  else
    depends_on 'clisp'
  end

  def install
    if ARGV.include? '--SBCL'
      cd 'Lisp' do
        system "sbcl", "--load", "install.lsp"
      end

      system "echo \"#!/bin/bash\nsbcl --core #{prefix}/Qi.core $*\" > qi"
      prefix.install ['Lisp/Qi.core']
    else
      cd 'Lisp' do
        system "clisp", "install.lsp"
      end

      system "echo \"#!/bin/bash\nclisp -M #{prefix}/Qi.mem $*\" > qi"
      prefix.install ['Lisp/Qi.mem']
    end
    system "chmod 755 qi"
    bin.install ['qi']
  end
end
