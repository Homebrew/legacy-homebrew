require 'formula'

class Neko < Formula
  url 'http://nekovm.org/_media/neko-1.8.1.tar.gz'
  homepage 'http://nekovm.org/'
  sha1 'a551ac615a98f8b75c67502cc977d64034e11f20'

  depends_on 'bdw-gc'

  def install
    ENV.deparallelize # parallel build fails
    system "yes s | make MACOSX=1 INSTALL_PREFIX='#{prefix}'"
    prefix.install %w{bin libs src}
  end
end
