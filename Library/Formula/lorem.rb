require 'formula'

class Lorem < Formula
  url 'http://lorem.googlecode.com/svn-history/r4/trunk/lorem'
  version '0.6.1'
  homepage 'http://code.google.com/p/lorem/'
  md5 '1246debbcb718aa56935e52136df17e8'

  aka 'ipsum'
  
  def download_strategy; CurlDownloadStrategy; end
  
  def install
    inreplace "lorem", "!/usr/bin/python", "!/usr/bin/env python"
    bin.install "lorem"
  end
end
