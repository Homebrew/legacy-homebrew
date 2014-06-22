require 'formula'

class Ii < Formula
  homepage 'http://tools.suckless.org/ii'
  url 'http://dl.suckless.org/tools/ii-1.7.tar.gz'
  sha1 '499f40b8d9cac6d2de0c27b1db087de6b819e279'

  def install
    inreplace 'config.mk' do |s|
      s.gsub! '/usr/local', prefix
      s.gsub! 'cc', ENV.cc
    end
    system "make install"
  end
end
