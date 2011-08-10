require 'formula'

class Fbida < Formula
  url 'http://dl.bytesex.org/releases/fbida/fbida-2.08.tar.gz'
  homepage 'http://linux.bytesex.org/fbida/'
  md5 '9b3693ab26a58194e36b479bffb61ed0'

  depends_on 'libexif'
  depends_on 'jpeg'

  def install
    system "make"
    bin.install 'exiftran'
    man1.install 'exiftran.man' => 'exiftran.1'
  end
end
