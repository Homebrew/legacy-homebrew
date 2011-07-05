require 'formula'

class Qi < Formula
  url 'http://www.lambdassociates.org/Download/QiII1.07.zip'
  homepage 'http://www.lambdassociates.org/'
  md5 '3a0b5c56d0f107f80f5bca11b82a4d59'

  depends_on 'clisp'

  def install
    system "cd Lisp; clisp install.lsp"
    system "echo \"#!/bin/bash\nclisp -M #{bin}/Qi.mem $*\" > qi"
    system "chmod 755 qi"
    bin.install ['Lisp/Qi.mem', 'qi']
  end
end
