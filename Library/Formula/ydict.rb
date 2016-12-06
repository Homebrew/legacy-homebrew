require 'formula'

class Ydict < Formula
  homepage 'http://code.google.com/p/ydict/'
  url 'http://ydict.googlecode.com/files/ydict-1.2.6.tar.gz'
  sha1 '08eb840c31964fb80c5f9af54a26e2bd6e622d6b'

  def ydict_wrapper; <<-EOS.undent
    #!/bin/sh
    LC_ALL=en_US.UTF-8 "#{bin}/ydict.py" "$@"
    EOS
  end

  def install
    bin.install 'ydict' => 'ydict.py'
    (bin/'ydict').write(ydict_wrapper)
  end
end
