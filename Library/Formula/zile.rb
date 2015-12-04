class Zile < Formula
  desc "Zile Is Lossy Emacs (ZILE)"
  homepage "https://www.gnu.org/software/zile/"
  url "http://ftpmirror.gnu.org/zile/zile-2.4.11.tar.gz"
  mirror "https://ftp.gnu.org/gnu/zile/zile-2.4.11.tar.gz"
  sha256 "1fd27bbddc61491b1fbb29a345d0d344734aa9e80cfa07b02892eedf831fa9cc"

  bottle do
    sha256 "a8981357a90d5d85fdcd834e73e5df5df787bb03bf7aac67b72224228d0e3224" => :mavericks
    sha256 "1a52c0ed8150383810178214e58b6c0d5456e6b3ba6d4723a057695443e3fcd8" => :mountain_lion
    sha256 "8c46b30da1358ca6440d76a9bb3e81c14373a58e9911aed0ee77ac0a446dafdd" => :lion
  end

  # https://github.com/mistydemeo/tigerbrew/issues/215
  fails_with :gcc_4_0 do
    cause "src/funcs.c:1128: error: #pragma GCC diagnostic not allowed inside functions"
  end

  fails_with :gcc do
    cause "src/funcs.c:1128: error: #pragma GCC diagnostic not allowed inside functions"
  end

  fails_with :llvm do
    cause "src/funcs.c:1128: error: #pragma GCC diagnostic not allowed inside functions"
  end

  depends_on "pkg-config" => :build
  depends_on "help2man" => :build
  depends_on "bdw-gc"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
