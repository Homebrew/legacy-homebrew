require 'formula'

class Loki < Formula
  url 'http://downloads.sourceforge.net/project/loki-lib/Loki/Loki%200.1.7/loki-0.1.7.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Floki-lib%2Ffiles%2FLoki%2FLoki%25200.1.7%2F&ts=1333050366&use_mirror=softlayer'
  homepage 'http://loki-lib.sourceforge.net/index.php?n=Main.HomePage'
  md5 '8261e83cf2c904fd915823336e7116bd'
  version '0.1.7'

  def install
    system "make" # Separate steps or install fails
    system "make install"
  end
end
