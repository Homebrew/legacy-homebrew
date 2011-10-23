require 'formula'

class Shen < Formula
  url 'http://www.shenlanguage.org/Download/Shen1.9sources.zip'
  homepage 'http://www.lambdassociates.org/'
  md5 'bf161cf83dc1ae3fc23454ad6aff02f7'
  version '1.9'

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
