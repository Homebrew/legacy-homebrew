require 'formula'

class Mscgen <Formula
  url 'http://www.mcternan.me.uk/mscgen/software/mscgen-src-0.18.tar.gz'
  homepage 'http://www.mcternan.me.uk/mscgen/'
  md5 '0922258a7fb86612bb623c1101260fd0' #b3a084a31070a0db2e0bb40a35825fac'

  depends_on 'pkg-config' => :build
  depends_on 'gd' => :recommended

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
