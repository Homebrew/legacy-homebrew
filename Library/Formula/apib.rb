require 'formula'

class Apib < Formula
  homepage 'https://github.com/apigee/apib'
  url 'https://github.com/apigee/apib/archive/APIB_1_0.tar.gz'
  sha1 'd7a5a2accd6bda7efeca433141b5df44ccd7f0b0'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install 'apib', 'apibmon'
  end

  test do
    system "#{bin}/apib", "-c 1", "-d 1", "http://www.google.com"
  end
end
