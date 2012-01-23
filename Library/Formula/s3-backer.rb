require 'formula'

class S3Backer < Formula
  url 'http://s3backer.googlecode.com/files/s3backer-1.3.2.tar.gz'
  homepage 'http://code.google.com/p/s3backer/'
  sha1 'badc003ffb0830a3fa59c9f39f13ad94729cbcf1'

  depends_on 'pkg-config' => :build
  depends_on 'fuse4x'

  def install
    inreplace "configure", "-lfuse", "-lfuse4x"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats
    <<-EOS.undent
      Make sure to follow the directions given by `brew info fuse4x-kext`
      before trying to use a FUSE-based filesystem.
    EOS
  end
end
