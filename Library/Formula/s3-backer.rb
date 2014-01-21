require 'formula'

class S3Backer < Formula
  homepage 'http://code.google.com/p/s3backer/'
  url 'http://s3backer.googlecode.com/files/s3backer-1.3.7.tar.gz'
  sha1 'c75c7e70cb38bcac41d342a2bdb63e9505ab550a'

  depends_on 'pkg-config' => :build
  depends_on 'osxfuse'

  def install
    inreplace "configure", "-lfuse", "-losxfuse"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats
    <<-EOS.undent
      Make sure to follow the directions given by `brew info osxfuse`
      before trying to use a FUSE-based filesystem.
    EOS
  end
end
