require 'formula'

class Libcmph < Formula
  homepage 'http://cmph.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/cmph/cmph/cmph-2.0.tar.gz'
  sha1 'eabdd4cd9f9bb2fed6773caac8d91638ad2d02b7'

  bottle do
    cellar :any
    sha1 "c4d510aad625eb17bc833ed979664a492403ce19" => :mavericks
    sha1 "1467eedfe3b9c9e6a06890133782a263faf67826" => :mountain_lion
    sha1 "0542344c8bb8a77bb2896d2129dff5c0cb1d2c22" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
