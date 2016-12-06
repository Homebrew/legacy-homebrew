require 'formula'

class Gcc46 < Formula
  url 'http://nchc.dl.sourceforge.net/project/hpc/hpc/gcc/gcc-snwleo-intel-bin.tar.gz'
  homepage ''
  md5 '9b62116e5d758ee5732e01aeda9a53f1'
  version '4.6'

  def install
    bin	   .install Dir['local/bin/*']
    include.install Dir['local/include/*']
    lib	   .install Dir['local/lib/*']
    libexec.install Dir['local/libexec/*']
    share  .install Dir['local/share/*']
  end
end
