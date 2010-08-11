require 'formula'

class Node <Formula
  url 'http://nodejs.org/dist/node-v0.1.103.tar.gz'
  head 'git://github.com/ry/node.git'
  homepage 'http://nodejs.org/'
  md5 '378307512e380e279969b0936e5ec5cc'

  # Stripping breaks dynamic loading
  skip_clean :all

  def options
    [["--debug", "Build with debugger hooks."]]
  end

  def install
    fails_with_llvm

    inreplace 'wscript' do |s|
      s.gsub! '/usr/local', HOMEBREW_PREFIX
      s.gsub! '/opt/local/lib', '/usr/lib'
    end

    args = ["--prefix=#{prefix}"]
    args << "--debug" if ARGV.include? '--debug'

    system "./configure", *args
    system "make install"
  end
end
