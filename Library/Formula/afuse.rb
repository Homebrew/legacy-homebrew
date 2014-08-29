require 'formula'

class Afuse < Formula
  homepage 'https://github.com/pcarrier/afuse/'
  url 'https://afuse.googlecode.com/files/afuse-0.4.1.tar.gz'
  sha1 '156b196a27c181eee8b192e7922fbe3c32c858e3'

  depends_on 'pkg-config' => :build
  depends_on 'osxfuse'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
