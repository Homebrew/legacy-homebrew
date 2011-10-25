require 'formula'

class S3fs < Formula
  homepage 'http://code.google.com/p/s3fs/'
  url 'http://s3fs.googlecode.com/files/s3fs-1.61.tar.gz'
  md5 '0dd7b7e9b1c58312cde19894488c5072'

  depends_on 'pkg-config' => :build
  depends_on 'fuse4x'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def caveats
    <<-EOS.undent
      Make sure to follow the directions given by `brew info fuse4x-kext`
      before trying to use a FUSE-based filesystem.

      Also, be aware that s3fs has some caveats concerning S3 "directories"
      that have been created by other tools. See the following issue for
      details:

        http://code.google.com/p/s3fs/issues/detail?id=73
    EOS
  end
end
