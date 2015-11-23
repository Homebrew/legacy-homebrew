class SuomiMalagaVoikko < Formula
  desc "Linguistic software and data for Finnish"
  homepage "http://voikko.puimula.org/"
  url "http://www.puimula.org/voikko-sources/suomi-malaga/suomi-malaga-1.18.tar.gz"
  sha256 "83655d56aa8255d8926ad3bafa190b8d7da32a0e3ff12150dc2dac31c92c5b0d"

  head "https://github.com/voikko/corevoikko.git"

  bottle do
    cellar :any
    sha256 "58e0c9c5f3577c7dc3b529a5547bd5c396164de856c9f14f91dd899d9e28e6d3" => :yosemite
    sha256 "f6517988b130926540d936cbf3b415b1ff2f5803d72d88c0672225e4aa410c46" => :mavericks
    sha256 "d4a98cf1328fc05aad4aa111b718df03c0b66a1f28da980f87a9a3c5231fa037" => :mountain_lion
  end

  depends_on "malaga"

  def install
    Dir.chdir "suomimalaga" if build.head?
    system "make", "voikko"
    system "make", "voikko-install", "DESTDIR=#{lib}/voikko"
  end
end
