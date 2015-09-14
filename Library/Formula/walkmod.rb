# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Walkmod < Formula
  homepage "http://www.walkmod.com"
  url "https://bitbucket.org/rpau/walkmod/downloads/walkmod-1.3.0-installer.zip"
  version "1.3.0"
  sha1 "1b23b4791f0090b4db183d4c894c3e0f623b5e63"

  depends_on :java

  def install
     #Remove windows files
     rm_f Dir["bin/*.bat"]
     
     libexec.install Dir["*"]

     bin.install_symlink libexec+"bin/walkmod"
  end

end
