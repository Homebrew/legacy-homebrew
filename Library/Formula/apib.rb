require 'formula'

class Apib < Formula
  homepage 'https://github.com/apigee/apib'
  url 'https://github.com/apigee/apib/archive/APIB_1_0.zip'
  sha1 '25d5b29bfab858e71ca166d29e9218bd39ba5cc6'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install 'apib', 'apibmon'
  end

  test do
    system "#{bin}/apib", "-c 1", "-d 1", "http://www.google.com"
  end
end
