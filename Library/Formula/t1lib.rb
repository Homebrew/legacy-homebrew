require 'formula'

class T1lib < Formula
  homepage 'http://www.t1lib.org/'
  url 'http://www.ibiblio.org/pub/Linux/libs/graphics/t1lib-5.1.2.tar.gz'
  sha1 '4b4fc22c8688eefaaa8cfc990f0039f95f4287de'

  def install
    system './configure', "--prefix=#{prefix}"
    system 'make', 'without_doc'
    system 'make', 'install'
    share.install 'Fonts' => 'fonts'
  end
end
