require 'formula'

class Hilite < Formula
  homepage 'http://sourceforge.net/projects/hilite/'
  url 'http://downloads.sourceforge.net/project/hilite/hilite/1.5/hilite.c'
  sha1 '96d551f1aae966d901e12076b59efd3e350e4192'

  def install
    system "#{ENV.cc} #{ENV.cflags} hilite.c -o hilite"
    bin.install 'hilite'
  end

  def test
    system "#{bin}/hilite", "bash", "-c", "echo 'stderr in red' >&2"
  end
end
