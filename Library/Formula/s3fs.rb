require 'formula'

class S3fs < Formula
  homepage 'http://code.google.com/p/s3fs/'
  url 'https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.76.tar.gz'
  sha1 '478aa3230b5d85bfe95d9962ee2f1d8cd35fa070'

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "fuse4x"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Be aware that s3fs has some caveats concerning S3 "directories"
    that have been created by other tools. See the following issue for
    details:

      http://code.google.com/p/s3fs/issues/detail?id=73
    EOS
  end
end
