require 'formula'

class Stlviewer < Formula
  homepage 'https://github.com/vishpat/stlviewer#readme'
  url 'https://github.com/vishpat/stlviewer/archive/master.zip'
  sha1 'fc8e8afd3e26fc194da1a4abd17dd3e971d81b61'
  # There is no versioning scheme, so I am using
  # version 1.<number of commits in master>
  version '1.14'

  def install
    system "./compile.py"
    system "cp ./stlviewer #{prefix}/stlviewer"
    system "ln -s #{prefix}/stlviewer /usr/local/bin/stlviewer"
  end

  test do
    system "stlviewer sample.stl"
  end
end
