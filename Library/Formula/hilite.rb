require 'formula'

class Hilite < Formula
  url 'http://downloads.sourceforge.net/project/hilite/hilite/1.5/hilite.c'
  version '1.5'
  homepage 'http://sourceforge.net/projects/hilite/'
  sha1 '96d551f1aae966d901e12076b59efd3e350e4192'

  def install
    system "#{ENV.cc} #{ENV.cflags} hilite.c -o hilite"
    bin.install 'hilite'
  end

  def test
    system "#{bin}/hilite", "bash", "-c", "echo 'stderr in red' >&2"
  end
end
