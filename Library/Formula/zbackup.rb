require 'formula'

class Zbackup < Formula
  homepage 'http://zbackup.org'
  url 'https://github.com/zbackup/zbackup/archive/1.2.tar.gz'
  sha1 'e87dfaeeeea0d59f4af00d3ce248aaabf1a25cb9'

  depends_on 'cmake' => :build
  depends_on 'openssl'
  depends_on 'protobuf'
  depends_on 'xz' # get liblzma compression algorithm library from XZutils

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/zbackup", '--non-encrypted', 'init', '.'
    system "echo test | #{bin}/zbackup backup backups/test.bak"
  end
end
