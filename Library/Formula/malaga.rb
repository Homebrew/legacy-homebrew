require 'formula'

class Malaga < Formula
  homepage 'http://home.arcor.de/bjoern-beutel/malaga/'
  url 'http://home.arcor.de/bjoern-beutel/malaga/malaga-7.12.tgz'
  sha1 '19d74697575229231c18c83bb7a16b7ee6c31a51'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gtk+' => :optional

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

end
