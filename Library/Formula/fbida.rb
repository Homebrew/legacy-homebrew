require 'formula'

class Fbida < Formula
  url 'http://dl.bytesex.org/releases/fbida/fbida-2.08.tar.gz'
  homepage 'http://linux.bytesex.org/fbida/'
  md5 '9b3693ab26a58194e36b479bffb61ed0'

  depends_on 'libexif'
  depends_on 'jpeg'

  def patches
    # Fixes crash when built against newer versions of jpeg
    # (fbida includes copies of libjpeg sources in "jpeg/",
    # and libjpeg has since been updated - this patch simply
    # replaces jpeg/*.{c,h} with updated files from libjpeg)
    # See also: https://qa.mandriva.com/show_bug.cgi?id=58212
    "http://thp.io/2011/archive/fbida-2.07.jpeg-v8c.patch.gz"
  end

  def install
    system "make"
    bin.install 'exiftran'
    man1.install 'exiftran.man' => 'exiftran.1'
  end
end
