require 'formula'

class Ydict < Formula
  homepage 'http://code.google.com/p/ydict/'
  url 'http://ydict.googlecode.com/files/ydict-1.3.1.tar.gz'
  sha1 'ac144b75cd221f69cc24b66340146341808871dd'

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
