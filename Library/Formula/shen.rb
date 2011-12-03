require 'formula'
class Shen < Formula
  url 'http://www.shenlanguage.org/download/Shen2.0.zip'
  homepage 'http://www.lambdassociates.org/'
  md5 '70770fe417e9d1a104f952a6acafb9ee'

  case
    when ARGV.include?("--sbcl") then
    depends_on 'sbcl'
  else
    depends_on 'clisp'
  end

  def options
    [["--sbcl", "Build SBCL version."]]
  end

  def install
    case
    when ARGV.include?("--sbcl") then
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
    bin.install ['shen']
  end
end
