require 'formula'

class Judy < Formula
  homepage 'http://judy.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/judy/judy/Judy-1.0.5/Judy-1.0.5.tar.gz'
  sha1 '3540f003509acac3b1260424380ddf97914f7745'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.j1 # Doesn't compile on parallel build
    system "make install"
  end
end
