require 'formula'

class Ttyrec < Formula
  homepage 'http://0xcc.net/ttyrec/'
  url 'http://0xcc.net/ttyrec/ttyrec-1.0.8.tar.gz'
  sha1 '645f1e2a1ac4b2a32ad314711fb3da014ce9684d'

  def install
    bin.mkpath
    system "make"
    bin.install %w[ ttytime ttyplay ttyrec ]
    man1.install Dir["*.1"]
  end
end
