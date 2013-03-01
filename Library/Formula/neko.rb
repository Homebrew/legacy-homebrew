require 'formula'

class Neko < Formula
  homepage 'http://nekovm.org/'
  url 'http://nekovm.org/_media/neko-1.8.2.tar.gz'
  sha1 '59f0fa72485b4c39561efbb64fc8c7293d372b0b'

  depends_on 'bdw-gc'

  def install
    ENV.deparallelize # parallel build fails
    system "yes s | make MACOSX=1 INSTALL_PREFIX='#{prefix}'"
    prefix.install %w{bin libs src}
  end
end
