class Zbackup < Formula
  desc "Globally-deduplicating backup tool (based on ideas in rsync)"
  homepage "http://zbackup.org"
  url "https://github.com/zbackup/zbackup/archive/1.4.3.tar.gz"
  sha256 "7bb027d34b98ae2c5aa5066177ba7a1542c786e16e52d47dc3c29bb326b1cd4a"

  bottle do
    cellar :any
    sha256 "53372b721ff3c84c47265572a9f41eb46c3a348e5a4351e1bf7c694a1d730430" => :yosemite
    sha256 "b011984aba098690937256105294b867baa2ee13f431be6340c26b56fd796565" => :mavericks
    sha256 "e71b3082ef5f7ebd00e7571d07de8624945124794074cb6d5335ce9de8b7c8c4" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "protobuf"
  depends_on "xz" # get liblzma compression algorithm library from XZutils
  depends_on "lzo"

  # These fixes are upstream and can be removed in version 1.5+
  patch do
    url "https://github.com/zbackup/zbackup/commit/7e6adda6b1df9c7b955fc06be28fe6ed7d8125a2.diff"
    sha256 "564c494b02be7b159b21f1cfcc963df29350061e050e66b7b3d96ed829552351"
  end

  patch do
    url "https://github.com/zbackup/zbackup/commit/f4ff7bd8ec63b924a49acbf3a4f9cf194148ce18.diff"
    sha256 "47f760aa03a0a1550f05e30b1fa127afa1eda5a802d0d6edd9be07f3762008fb"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/zbackup", "--non-encrypted", "init", "."
    system "echo test | #{bin}/zbackup --non-encrypted backup backups/test.bak"
  end
end
