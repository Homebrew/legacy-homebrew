require 'formula'

class Gcalcli < Formula
  url 'http://gcalcli.googlecode.com/files/gcalcli-2.1.tgz'
  homepage 'http://code.google.com/p/gcalcli/'
  md5 'eb7bda97c7e30dffc05c3d8bb4dda094'
  head 'https://code.google.com/p/gcalcli/', :using => :git

  depends_on 'dateutil' => :python
  depends_on 'vobject' => :python
  depends_on 'elementtree' => :python
  depends_on 'gdata' => :python

  def install
    #Replaces hard-coded python2 dependency with system python
    inreplace 'gcalcli', "#!/usr/bin/python2", "#!/usr/bin/env python"
    bin.install("gcalcli")
  end

  def test
    system "gcalcli --version"
  end
end
