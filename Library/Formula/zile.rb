class Zile < Formula
  desc "Zile Is Lossy Emacs (ZILE)"
  homepage "https://www.gnu.org/software/zile/"
  url "http://ftpmirror.gnu.org/zile/zile-2.4.11.tar.gz"
  mirror "https://ftp.gnu.org/gnu/zile/zile-2.4.11.tar.gz"
  sha256 "1fd27bbddc61491b1fbb29a345d0d344734aa9e80cfa07b02892eedf831fa9cc"

  bottle do
    sha1 "6112330f840500f201c9903a67003f22c484e458" => :mavericks
    sha1 "0daeecd50c14a9338527fcfc367f96487d538cd4" => :mountain_lion
    sha1 "1a32cf3d3c235bba1fd570e7bff81190851ec411" => :lion
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
