require 'formula'

class Node <Formula
  url 'http://nodejs.org/dist/node-v0.2.1.tar.gz'
  head 'git://github.com/ry/node.git'
  homepage 'http://nodejs.org/'
  md5 'c6051dd216817bf0f95bea80c42cf262'

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
