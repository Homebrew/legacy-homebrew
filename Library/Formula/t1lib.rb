require 'formula'

class T1lib < Formula
  homepage 'http://www.t1lib.org/'
  url 'http://www.ibiblio.org/pub/Linux/libs/graphics/t1lib-5.1.2.tar.gz'
  sha1 '4b4fc22c8688eefaaa8cfc990f0039f95f4287de'

  bottle do
    sha1 "d17c526466d2b29f46af3e8f9cacdcddf64f1879" => :mavericks
    sha1 "100577d05c39018442328dec9a604b2302f171c6" => :mountain_lion
    sha1 "008ed36af21397ae34d6ec47aff7301aa599d890" => :lion
  end

  def install
    system './configure', "--prefix=#{prefix}"
    system 'make', 'without_doc'
    system 'make', 'install'
    share.install 'Fonts' => 'fonts'
  end
end
