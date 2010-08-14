require 'formula'

class Perforce <Formula
  url 'http://filehost.perforce.com/perforce/r10.1/bin.darwin80u/p4'
  homepage 'http://www.perforce.com/'
  md5 '4170d202a4bda079e334c7dc5c37c417'
  version '2010.1.251161'

  def install
    bin.install 'p4'
  end
end
