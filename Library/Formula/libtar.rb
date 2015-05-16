require 'formula'

class Libtar < Formula
  homepage 'http://repo.or.cz/w/libtar.git'
  url 'http://repo.or.cz/w/libtar.git/snapshot/v1.2.20.tar.gz'
  sha1 '3432cc24936d23f14f1e74ac1f77a1b2ad36dffa'

  bottle do
    cellar :any
    revision 1
    sha1 "18d378564e3507204dd29e84bf09840e335206a2" => :yosemite
    sha1 "bcbd1747ca7827d795a13d11648d72ecb5b5e1a2" => :mavericks
    sha1 "96e778eed9bba1d3cfd8fbc81e616ad580770a84" => :mountain_lion
  end

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
