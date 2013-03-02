require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Nconvert < Formula
  homepage 'http://www.xnview.com/en/nconvert.html'
  url 'http://download.xnview.com/NConvert-macosx.tgz'
  sha1 '11b09a62c1c7f3feeb53718e46a70652074e077b'

  def install
    bin.install 'nconvert'
  end
end
