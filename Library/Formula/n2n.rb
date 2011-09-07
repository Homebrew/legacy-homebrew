require 'formula'

class N2n < Formula
  url 'http://www.sideshowcoder.railsplayground.net/files/n2n-2.7.tar.gz'
  homepage 'http://www.ntop.org/n2n/'
  md5 '8e64e4fd0ebf05c76b942549dc8b6b76'

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  def caveats; <<-EOF.undent
    n2n requires the tun/tap devices. To get these on OS X:
      http://tuntaposx.sourceforge.net/download.xhtml
    EOF
  end
end
