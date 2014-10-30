require "formula"

class S3fs < Formula
  homepage "http://code.google.com/p/s3fs/"
  url "https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.78.tar.gz"
  sha1 "613b448d84451400d3ee14aa9104ba6d9e90bd0b"
  revision 1

  head "https://github.com/s3fs-fuse/s3fs-fuse.git"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl"
  depends_on "fuse4x"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Be aware that s3fs has some caveats concerning S3 "directories"
    that have been created by other tools. See the following issue for
    details:

      http://code.google.com/p/s3fs/issues/detail?id=73
    EOS
  end
end
