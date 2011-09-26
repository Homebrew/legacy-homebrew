require 'formula'

class Shen < Formula
  url 'http://www.lambdassociates.org/Download/Shen1.7sources.zip'
  homepage 'http://www.lambdassociates.org/'
  md5 'e46ba5ab02c6e1de4ba2f5d9340e355a'
  version '1.7'

  depends_on 'clisp'

  def install
    system "cp K\\ Lambda/* Platforms/CLisp"
    safe_system "cd Platforms/CLisp; clisp -i install.lsp"
    system "echo \"#!/bin/bash\nclisp -M #{prefix}/Shen.mem $*\" > shen"
    prefix.install ['Platforms/CLisp/Shen.mem']
    system "chmod 755 shen"
    bin.install ['shen']
  end
end
