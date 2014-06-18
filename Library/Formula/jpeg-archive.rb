require 'formula'

class JpegArchive < Formula
  homepage 'https://github.com/danielgtaylor/jpeg-archive'
  url 'https://github.com/danielgtaylor/jpeg-archive/archive/1.0.1.tar.gz'
  sha1 '45d36e74ae795d25e8cbf20d2ccd3ae17d4c6f7b'

  depends_on 'jpeg-turbo'

  def install
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/jpeg-recompress", "--help"
  end
end
