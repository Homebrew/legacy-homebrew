require 'formula'

class Node <Formula
  url 'http://s3.amazonaws.com/four.livejournal/20091128/node-v0.1.20.tar.gz'
  homepage 'http://nodejs.org/'
  md5 'ba906befa4cb6f36ef4a5200931d4853'

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
