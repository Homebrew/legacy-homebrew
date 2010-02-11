require 'formula'

class Node <Formula
  url 'http://s3.amazonaws.com/four.livejournal/20100209/node-v0.1.28.tar.gz'
  head 'git://github.com/ry/node.git'
  homepage 'http://nodejs.org/'
  md5 '3879560dc135151657883d566c78c502'

  aka 'node.js'
  
  depends_on 'gnutls' => :recommended
  
  def skip_clean? path
    # TODO: at some point someone should tweak this so it only skips clean
    # for the bits that break the build otherwise
    true
  end

  def install
    ENV.gcc_4_2
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
