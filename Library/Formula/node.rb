require 'formula'

class Node <Formula
  url 'http://nodejs.org/dist/node-v0.1.98.tar.gz'
  head 'git://github.com/ry/node.git'
  homepage 'http://nodejs.org/'
  md5 'd8a75cb5c18ce20e0206ced95a8c1544'

  aka 'node.js'
  
  def skip_clean? path
    # TODO: at some point someone should tweak this so it only skips clean
    # for the bits that break the build otherwise
    true
  end

  def install
    fails_with_llvm
    inreplace %w{wscript configure} do |s|
      s.gsub! '/usr/local', HOMEBREW_PREFIX
      s.gsub! '/opt/local/lib', '/usr/lib'
    end
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
