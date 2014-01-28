require 'formula'

class Afflib < Formula
  homepage 'https://github.com/simsong/AFFLIBv3'
  url 'https://github.com/simsong/AFFLIBv3/archive/v3.7.4.tar.gz'
  sha1 '589dae6f8439e97ab080026701cd0caa0636ac22'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'expat' => :optional

  def install
    system "sh bootstrap.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
