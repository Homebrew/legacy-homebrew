require 'formula'

class Node <Formula
  url 'http://nodejs.org/dist/node-v0.1.104.tar.gz'
  head 'git://github.com/ry/node.git'
  homepage 'http://nodejs.org/'
  md5 '907fa1e0a2f1f0c3df5efc97fd05a7d2'

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
