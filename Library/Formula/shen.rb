require 'formula'

class Shen < Formula
  url 'http://www.lambdassociates.org/Download/Shen1.8sources.zip'
  homepage 'http://www.lambdassociates.org/'
  md5 'bbd8d527683859f2bc3e6ee9bf439e50'
  version '1.8'

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
