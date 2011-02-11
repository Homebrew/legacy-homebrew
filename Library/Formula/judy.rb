require 'formula'

class Judy <Formula
  url 'http://downloads.sourceforge.net/project/judy/judy/Judy-1.0.5/Judy-1.0.5.tar.gz'
  homepage 'http://judy.sourceforge.net/'
  md5 '115a0d26302676e962ae2f70ec484a54'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.j1 # Doesn't compile on parallel build
    system "make install"
  end
end
