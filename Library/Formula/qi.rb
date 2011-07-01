require 'formula'

class Qi < Formula
  url 'http://www.lambdassociates.org/Download/QiII1.07.zip'
  homepage 'http://www.lambdassociates.org/'
  md5 '3a0b5c56d0f107f80f5bca11b82a4d59'

  depends_on 'sbcl'

  def install
    system "cd Lisp; sbcl --load 'install.lsp'"
    system "echo \"#!/bin/bash\nsbcl --core #{bin}/Qi.core $*\" > qi"
    system "chmod 755 qi"
    bin.install ['Lisp/Qi.core', 'qi']
  end
end
