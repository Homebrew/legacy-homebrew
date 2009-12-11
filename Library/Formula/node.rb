require 'formula'

class Node <Formula
  url 'http://s3.amazonaws.com/four.livejournal/20091206/node-v0.1.21.tar.gz'
  homepage 'http://nodejs.org/'
  md5 'c72b29a803d9bb3aed0fce5245d8b03b'

  aka 'node.js'

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
