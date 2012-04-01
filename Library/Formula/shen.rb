require 'formula'

class Shen < Formula
  homepage 'http://www.shenlanguage.org/'
  url 'http://www.shenlanguage.org/download/Shen3.1.zip'
  md5 'ecc1ed39c499417b9408157982559319'

  if ARGV.include? "--sbcl"
    depends_on 'sbcl'
  else
    depends_on 'clisp'
  end

  def options
    [["--sbcl", "Build SBCL version."]]
  end

  def install
    if ARGV.include?("--sbcl") then
      system "cp K\\ Lambda/* Platforms/SBCL"
      safe_system "cd Platforms/SBCL; sbcl --load install.lsp"
      system "mv Platforms/SBCL/Shen.exe shen"
    else
      system "cp K\\ Lambda/* Platforms/CLisp"
      safe_system "cd Platforms/CLisp; clisp -i install.lsp"
      system "echo \"#!/bin/bash\nclisp -M #{prefix}/Shen.mem $*\" > shen"
      prefix.install ['Platforms/CLisp/Shen.mem']
    end
    system "chmod 755 shen"
    bin.install 'shen'
  end
end
