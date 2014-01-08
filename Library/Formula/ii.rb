require 'formula'

class Ii < Formula
  homepage 'http://tools.suckless.org/ii'
  url 'http://dl.suckless.org/tools/ii-1.6.tar.gz'
  sha1 'cd6c2a6c97d1e4d46018709bb25ff96fbdb47d33'

  def install
    inreplace 'config.mk' do |s|
      s.gsub! '/usr/local', prefix
      s.gsub! 'cc', ENV.cc
    end
    system "make install"
  end
end
