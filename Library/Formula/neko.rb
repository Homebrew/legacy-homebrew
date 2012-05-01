require 'formula'

class Neko < Formula
  url 'http://nekovm.org/_media/neko-1.8.1.tar.gz'
  homepage 'http://nekovm.org/'
  md5 '0e2029465a49e1da929f0e254c017701'

  depends_on 'bdw-gc'

  def install
    ENV.deparallelize # parallel build fails
    system "yes s | make MACOSX=1 INSTALL_PREFIX=#{prefix}"
    prefix.install %w{bin libs src}
  end
end
