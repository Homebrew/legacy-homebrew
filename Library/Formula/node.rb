require 'formula'

class Node <Formula
  url 'http://nodejs.org/dist/node-v0.1.101.tar.gz'
  head 'git://github.com/ry/node.git'
  homepage 'http://nodejs.org/'
  md5 'd6bb2c6fb87631e4801d281486329d16'

  aka 'node.js'

  # Stripping breaks dynamic loading
  def skip_clean? path
    true
  end

  def install
    fails_with_llvm

    inreplace 'wscript' do |s|
      s.gsub! '/usr/local', HOMEBREW_PREFIX
      s.gsub! '/opt/local/lib', '/usr/lib'
    end

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
