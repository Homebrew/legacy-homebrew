require 'formula'

class Arabica < Formula
  homepage 'http://www.jezuk.co.uk/cgi-bin/view/arabica'
  url 'http://downloads.sourceforge.net/project/arabica/arabica/November-12/arabica-2012-November.tar.gz'
  version '20121126'
  sha1 '34d043607e048e0972a57e31bfff09086d893d14'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
