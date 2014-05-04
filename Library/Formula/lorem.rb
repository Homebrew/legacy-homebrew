require 'formula'

class Lorem < Formula
  homepage 'http://code.google.com/p/lorem/'
  url 'http://lorem.googlecode.com/svn-history/r4/trunk/lorem', :using => :curl
  version '0.6.1'
  sha1 'aa6ef66e5ee1151397f19b358d772af316cf333b'

  def install
    inreplace "lorem", "!/usr/bin/python", "!/usr/bin/env python"
    bin.install "lorem"
  end

  test do
    assert_equal "lorem ipsum", shell_output("#{bin}/lorem -n 2").strip
  end
end
