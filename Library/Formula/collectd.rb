require 'formula'

class Collectd <Formula
  url 'http://collectd.org/files/collectd-4.10.1.tar.bz2'
  homepage 'http://collectd.org/'
  md5 '8cd79b4ebdb9dbeb51ba52d3463a06ef'

  skip_clean :all

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}", "--localstatedir=#{var}"]
    args << "--disable-embedded-perl" if MACOS_VERSION < 10.6

    system "./configure", *args
    system "make install"
  end
end
