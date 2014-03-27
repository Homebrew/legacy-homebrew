require 'formula'

class Spim < Formula
  homepage 'http://spimsimulator.sourceforge.net/'
  # No source code tarball exists
  url 'http://svn.code.sf.net/p/spimsimulator/code', :revision => 641
  version '9.1.13'

  bottle do
    sha1 "98be77d9b3af625b26981a5c53c10d74b6754bee" => :mavericks
    sha1 "5ddae3d5c9d714e8db69e34e1c76760ce82bce87" => :mountain_lion
    sha1 "c5f9128b9fdc7ba4a0c0fe77179ee241942be420" => :lion
  end

  def install
    bin.mkpath
    cd 'spim' do
      system "make", "EXCEPTION_DIR=#{share}"
      system "make", "install", "BIN_DIR=#{bin}",
                                "EXCEPTION_DIR=#{share}",
                                "MAN_DIR=#{man1}"
    end
  end
end
