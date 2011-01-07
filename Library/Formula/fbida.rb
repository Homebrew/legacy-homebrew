require 'formula'

class Fbida <Formula
  url 'http://dl.bytesex.org/releases/fbida/fbida-2.07.tar.gz'
  homepage 'http://linux.bytesex.org/fbida/'
  md5 '3e05910fb7c1d9b2bd3e272d96db069c'

  depends_on 'libexif'
  depends_on 'jpeg'

  def install
    system "make"
    bin.install 'exiftran'
    man1.install 'exiftran.man' => 'exiftran.1'
  end
end
