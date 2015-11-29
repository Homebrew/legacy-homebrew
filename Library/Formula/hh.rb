class Hh < Formula
  desc "Bash and zsh history suggest box"
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/releases/download/1.19/hh-1.19-src.tgz"
  sha256 "b67cb5e2515948fd0fb402b732630a51885be5dfe58cbf914c22ea444129a647"

  bottle do
    cellar :any
    sha256 "8e5a229c8733c28bc6655d2fa3c1ac141be27780d851e37c9b512861c53b3113" => :el_capitan
    sha256 "ceb89140b07409845bd3bd40cafb9dcf65ff65de35a634d013455a100c6e8066" => :yosemite
    sha256 "192d154897ebce7cb5b55e0ca1c0cc8503ac9bd5e1e5cc2bc8a7f7fe7aee188d" => :mavericks
    sha256 "50dc71816420d5ec1fdcb90cd9ef82a0ee47208250c8525f72e238aa90a0404c" => :mountain_lion
  end

  head do
    url "https://github.com/dvorka/hstr.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "readline"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/".hh_test"
    path.write "test\n"
    ENV["HISTFILE"] = path
    assert_equal "test\n", `#{bin}/hh -n`
  end
end
