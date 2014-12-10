require 'formula'

class Mp3wrap < Formula
  homepage 'http://mp3wrap.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/mp3wrap/mp3wrap/mp3wrap%200.5/mp3wrap-0.5-src.tar.gz'
  sha1 '458b7e9dce5d7a867b1be73554dd14043a4cd421'

  bottle do
    cellar :any
    sha1 "5569a9dbeabf76247ef2e98fdeb6f0c8fda4c188" => :mavericks
    sha1 "691e84d652214da84193bd6ca194cf308fed986d" => :mountain_lion
    sha1 "bd461a4b06439c0fb736fd5546607e5261d9130b" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
