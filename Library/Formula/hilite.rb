require 'formula'

class Hilite < Formula
  url 'http://downloads.sourceforge.net/project/hilite/hilite/1.5/hilite.c'
  version '1.5'
  homepage 'http://sourceforge.net/projects/hilite/'
  md5 '0214a3ef553cf4cf1e41f9c3bf93ca83'

  def install
    system "#{ENV.cc} #{ENV.cflags} hilite.c -o hilite"
    bin.install 'hilite'
  end

  def test
    `hilite bash -c "echo 'stderr in red' >&2"`
  end
end
