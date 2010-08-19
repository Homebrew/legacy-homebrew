require 'formula'

class Lorem < Formula
  url 'http://lorem.googlecode.com/svn-history/r4/trunk/lorem',
        :using => :curl
  version '0.6.1'
  homepage 'http://code.google.com/p/lorem/'
  md5 '1246debbcb718aa56935e52136df17e8'

  def install
    inreplace "lorem", "!/usr/bin/python", "!/usr/bin/env python"
    bin.install "lorem"
  end
end
