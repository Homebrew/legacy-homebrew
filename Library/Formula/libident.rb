require 'formula'

class Libident < Formula
  desc "Ident protocol library"
  homepage 'http://www.remlab.net/libident/'
  url 'http://www.remlab.net/files/libident/libident-0.32.tar.gz'
  sha1 '4658807b017f21928a64f3442ee3a2b91f48d14e'

  bottle do
    cellar :any
    revision 1
    sha1 "64d49643f318b06a290951083fe02e28956288dc" => :yosemite
    sha1 "2d309cbd2783f327c92ff5ea640e052059bb6d43" => :mavericks
    sha1 "e449ccd40b06a2b32cc1c36d076354a5402e7df3" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
