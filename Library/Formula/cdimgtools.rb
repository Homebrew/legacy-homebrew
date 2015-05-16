require 'formula'

class Cdimgtools < Formula
  homepage 'http://home.gna.org/cdimgtools/'
  url 'http://download.gna.org/cdimgtools/cdimgtools-0.3.tar.gz'
  sha1 'bc4d9f7b50aa59e3f4f32fc61c01b6a8241eb1af'
  head 'https://git.gitorious.org/cdimgtools/cdimgtools.git'

  depends_on 'libdvdcss'
  depends_on 'libdvdread'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "install-doc-man"
  end

  test do
    system "#{bin}/dvdimgdecss", "-V"
    system "#{bin}/cssdec", "-V"
  end
end
