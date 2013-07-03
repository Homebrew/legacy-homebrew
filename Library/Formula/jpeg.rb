require 'formula'

class Jpeg < Formula
  homepage 'http://www.ijg.org'
  url 'http://www.ijg.org/files/jpegsrc.v8d.tar.gz'
  sha1 'f080b2fffc7581f7d19b968092ba9ebc234556ff'

  bottle do
    revision 1
    sha1 'efdcddaee959b85d35a232ddcf1e7ae0577a8704' => :mountain_lion
    sha1 '17b90896ea0f517fb980e8f82ad8baa8f3639e43' => :lion
    sha1 '5df0f135a9e43cd37d69b4ec6022323d72c477ae' => :snow_leopard
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    # Builds static and shared libraries.
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
