require 'formula'

class Node <Formula
  url 'http://nodejs.org/dist/node-v0.4.0.tar.gz'
  head 'git://github.com/ry/node.git'
  homepage 'http://nodejs.org/'
  md5 '18f89256751f9b8e27dee8494f508171'

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

  def caveats
    "Please add #{HOMEBREW_PREFIX}/lib/node to your NODE_PATH environment variable to have node libraries picked up."
  end
end
