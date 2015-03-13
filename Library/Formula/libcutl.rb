class Libcutl < Formula
  homepage "http://www.codesynthesis.com/projects/libcutl/"
  url "http://www.codesynthesis.com/download/libcutl/1.9/libcutl-1.9.0.tar.gz"
  sha256 "1b575aa8ed74aa36adc0f755ae9859c6e48166a60779a5564dd21b8cb05afb7d"

  depends_on "gcc" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  fails_with :clang do
    cause <<-EOS.undent
    Oh! It seems that you only have clang available, or GCC wasn't found!
    Make sure you GCC is installed and recognized by homebrew.
    EOS
  end

  test do
    system "false"
  end
end
