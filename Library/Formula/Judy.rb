require 'formula'

class Judy <Formula
  url 'https://downloads.sourceforge.net/project/judy/judy/Judy-1.0.5/Judy-1.0.5.tar.gz?r=&ts=1291217517&use_mirror=heanet'
  homepage 'http://judy.sourceforge.net/'
  md5 '115a0d26302676e962ae2f70ec484a54'
  version '1.0.5'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make -j1 install"
  end
end
