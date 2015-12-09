class Kes < Formula
  desc "Fork of the es shell based on the rc command interpreter"
  homepage "https://github.com/epilnivek/kes"
  url "https://github.com/epilnivek/kes/archive/v0.9.tar.gz"
  sha256 "d0db16ba7892d9692cacd552d684f03a9d0333ba0e7b629a998fa9c127ef050e"

  head "https://github.com/epilnivek/kes.git"

  bottle do
    cellar :any
    revision 1
    sha256 "815f563b2241d50bccb124ce4e8ad8b96ed73ec1445463248063387f0d7846aa" => :el_capitan
    sha256 "1c3cbda6f56cedc9998f90db05a0081773d950e27fde2f8b90ad487c9b338c19" => :yosemite
    sha256 "0a44427107749d609577253273d6b7b5b4f81b06ad29660b0d5802d5e5f71f40" => :mavericks
  end

  depends_on "readline"

  conflicts_with "es", :because => "both install 'es' binary"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-readline"

    bin.mkpath
    man1.mkpath

    system "make", "install"
  end

  test do
    assert_equal "Homebrew\n", shell_output("#{bin}/es -c 'echo Homebrew'")
  end
end
