require 'formula'

class S3Backer < Formula
  homepage 'http://code.google.com/p/s3backer/'
  url 'http://s3backer.googlecode.com/files/s3backer-1.3.3.tar.gz'
  sha1 '0aa837279c9232260a8f9d0d76097b144684044f'

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
