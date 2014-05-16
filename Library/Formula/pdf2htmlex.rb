require 'formula'

class Pdf2htmlex < Formula
  homepage 'http://coolwanglu.github.io/pdf2htmlEX/'
  url 'https://github.com/coolwanglu/pdf2htmlEX/archive/v0.11.tar.gz'
  sha256 'eca83144daf298b25c5b9bedb59d8e21ba65eb5e246d61f897447bc917ec0cba'

  head 'https://github.com/coolwanglu/pdf2htmlEX.git'

  depends_on :macos => :lion
  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'fontforge'
  depends_on 'poppler'
  depends_on 'ttfautohint' => :recommended if MacOS.version > :snow_leopard

  # Fix build with recent poppler
  patch do
    url "https://github.com/coolwanglu/pdf2htmlEX/commit/c0371a07a678bebf2e6991c94eb245ec1c3f95cf.diff"
    sha1 "5bbc19ff74955c2f81f858432f4f97c37a0dbc26"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make install"
  end

  test do
    curl "-O", "http://partners.adobe.com/public/developer/en/xml/AdobeXMLFormsSamples.pdf"
    system "#{bin}/pdf2htmlEX", "AdobeXMLFormsSamples.pdf"
  end
end
