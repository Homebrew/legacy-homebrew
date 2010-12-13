require 'formula'

class Liboping <Formula
  url 'http://verplant.org/liboping/files/liboping-1.4.0.tar.bz2'
  homepage 'http://verplant.org/liboping/'
  sha256 'ca237ca16607f982aa7b4405e8e3aeea2f655e9d39ba4aff77974c66ee9631bd'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
