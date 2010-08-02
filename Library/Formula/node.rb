require 'formula'

class Node <Formula
  url 'http://nodejs.org/dist/node-v0.1.102.tar.gz'
  head 'git://github.com/ry/node.git'
  homepage 'http://nodejs.org/'
  md5 '93279f1e4595558dacb45a78259b7739'

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
