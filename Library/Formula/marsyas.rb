require 'formula'

class Marsyas < Formula
  homepage 'http://marsyas.info/'
  url 'http://downloads.sourceforge.net/project/marsyas/marsyas/marsyas-0.4.7.tar.gz'
  sha1 '8cf6916a4f02fc6bd75f697dc3e16d9fe7cb86bf'

  keg_only "This brew installs more than 30 commands, some with dangerously short names."

  depends_on 'cmake' => :build

  def install
    system "cmake", "src", *std_cmake_args
    system "make install"
  end
end
