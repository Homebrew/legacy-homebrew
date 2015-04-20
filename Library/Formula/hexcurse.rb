require 'formula'

class Hexcurse < Formula
  homepage 'https://github.com/LonnyGomes/hexcurse'
  url 'https://github.com/LonnyGomes/hexcurse/archive/hexcurse-1.58.tar.gz'
  sha1 '6a07324a4782007dcea800b8b545f9f07e8eae8f'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
      system "#{bin}/hexcurse", "-help"
  end
end
