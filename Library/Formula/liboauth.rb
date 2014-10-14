require 'formula'

class Liboauth < Formula
  homepage 'http://liboauth.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/liboauth/liboauth-1.0.3.tar.gz'
  sha1 '791dbb4166b5d2c843c8ff48ac17284cc0884af2'

  bottle do
    cellar :any
    sha1 "629338632e3bc565c467e78ec3eda027e5dc8f5f" => :mavericks
    sha1 "beb85d4344d6fe052a6f0fd86660d23ac719b004" => :mountain_lion
    sha1 "e7412537949792cec74e50bb2a04c4b1f6116094" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-curl"
    system "make install"
  end
end
