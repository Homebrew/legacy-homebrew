require 'formula'

class Muparser < Formula
  homepage 'http://muparser.beltoforion.de/'
  url 'https://docs.google.com/uc?export=download&confirm=no_antivirus&id=0BzuB-ydOOoduZjlFOEFRREZrT2s'
  sha1 '3974898052dd9ef350df1860f8292755f78f59df'
  version '2.2.3'

  bottle do
    cellar :any
    sha1 "5770d673e9eb9f55504eed8828c23508d1140399" => :mavericks
    sha1 "62a89223d3ae31a0bcc18adb31f5bb9ad570018f" => :mountain_lion
    sha1 "0e10886b7ca3e5c294f7d8e5913e66889f309175" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
