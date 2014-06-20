require 'formula'

class Ophcrack < Formula
  homepage 'http://ophcrack.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/ophcrack/ophcrack/3.6.0/ophcrack-3.6.0.tar.bz2'
  sha1 '8e39b8c013b3f2144b23e33abeeadbb81e4120ca'

  def install
    system "./configure", "--disable-debug",
                          "--disable-gui",
                          "--prefix=#{prefix}"

    system "make"
    system "make", "-C", "src", "install"
  end
end
