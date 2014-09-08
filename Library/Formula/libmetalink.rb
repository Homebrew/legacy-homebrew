require 'formula'

class Libmetalink < Formula
  homepage 'https://launchpad.net/libmetalink/'
  url 'https://launchpad.net/libmetalink/trunk/packagingfix/+download/libmetalink-0.1.2.tar.bz2'
  sha1 'fcc8c7960758c040b8b5f225efeb3f22bff14e40'

  bottle do
    cellar :any
    sha1 "7c6aba1ee90cb6fecf96eef3e040a1c9c54f96c3" => :mavericks
    sha1 "d7542102350449dedfc2f1dd87e9fcc9b362ff79" => :mountain_lion
    sha1 "52c2b02b8c723f522df587f1ec26894a783ed224" => :lion
  end

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
