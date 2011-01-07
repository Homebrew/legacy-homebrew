require 'formula'

class Libopenspotify <Formula
  head 'git://github.com/noahwilliamsson/openspotify.git'
  homepage 'https://github.com/noahwilliamsson/openspotify'

  depends_on 'libogg'
  depends_on 'libvorbis'

  def install
    system "make -C libopenspotify install prefix=#{prefix}"
  end
end
