require 'formula'

class Feh < Formula
  url 'http://feh.finalrewind.org/feh-1.14.2.tar.bz2'
  homepage 'http://freshmeat.net/projects/feh'
  md5 '5a64a93ae00f2f4189a6119e835d4452'

  depends_on 'giblib' => :build

  def install
    ENV.x11

    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
