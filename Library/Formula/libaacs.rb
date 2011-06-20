require 'formula'

class Libaacs < Formula
  url 'git://git.videolan.org/libaacs.git', :commit => "2a7427078cac41c84599c30054500dae92dc54b5"
  homepage 'http://www.videolan.org/developers/libaacs.html'
  version '2a7427078cac41c84599c30054500dae92dc54b5'

  def install
    system './bootstrap'
    system "./configure", "--disable-extra-warnings", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
