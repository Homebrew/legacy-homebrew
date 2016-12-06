require 'formula'

class Nanomsg < Formula
  homepage 'http://nanomsg.org/'

  url 'git://github.com/250bpm/nanomsg.git', :revision => '729e35b0545e12cfd5a271656a7cd850f7a9e8cc'
  version '0.0.0-729e35b'

  head 'git://github.com/250bpm/nanomsg.git'

  depends_on 'cmake' => :build

  def install
    system 'mkdir build'

    cd 'build' do
      system 'cmake', '..', *std_cmake_args
      system 'make install'
    end
  end

  def test
    system "test -f /usr/local/lib/libnanomsg.dylib && test -f /usr/local/include/nanomsg/nn.h"
  end
end
