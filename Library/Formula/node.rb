require 'formula'

class Node <Formula
  url 'http://nodejs.org/dist/node-v0.1.29.tar.gz'
  head 'git://github.com/ry/node.git'
  homepage 'http://nodejs.org/'
  md5 '0932e11b9eb91c466146ca05cf6e34c1'

  aka 'node.js'
  
  depends_on 'gnutls' => :recommended
  
  def skip_clean? path
    # TODO: at some point someone should tweak this so it only skips clean
    # for the bits that break the build otherwise
    true
  end

  def install
    inreplace %w{wscript configure} do |wscript|
      wscript.gsub! '/usr/local', HOMEBREW_PREFIX
      wscript.gsub! '/opt/local/lib', '/usr/lib'
    end
    ENV.gcc_4_2
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
