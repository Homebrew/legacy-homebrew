require 'formula'

class Ttyrec < Formula
  url 'http://0xcc.net/ttyrec/ttyrec-1.0.8.tar.gz'
  homepage 'http://0xcc.net/ttyrec/'
  md5 'ee74158c6c55ae16327595c70369ef83'

  def install
    bin.mkpath
    system "make"
    bin.install %w[ ttytime ttyplay ttyrec ]
    man1.install Dir["*.1"]
  end
end
