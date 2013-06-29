require 'formula'

class Ophcrack < Formula
  homepage 'http://ophcrack.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/ophcrack/ophcrack/3.4.0/ophcrack-3.4.0.tar.bz2'
  sha1 '346f7e4689f2c0fc65ba7087b1ae91d00edf15b6'

  def install
    system "./configure", "--disable-debug",
                          "--disable-gui",
                          "--prefix=#{prefix}"

    system "make"
    cd 'src' do
      system "make install"
    end
  end
end
