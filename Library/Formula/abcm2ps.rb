require 'formula'

class Abcm2ps < Formula
  homepage 'http://moinejf.free.fr'
  url 'http://moinejf.free.fr/abcm2ps-6.6.22.tar.gz'
  sha1 'a59dad019320e5931f54cf3788bc19d4e095f836'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/abcm2ps"
  end
end
