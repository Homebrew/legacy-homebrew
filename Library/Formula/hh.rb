class Hh < Formula
  desc "Bash and zsh history suggest box"
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/releases/download/1.19/hh-1.19-src.tgz"
  sha256 "b67cb5e2515948fd0fb402b732630a51885be5dfe58cbf914c22ea444129a647"

  bottle do
    cellar :any
    sha256 "b241ad9ec87ae46d2e125fa939294a6aea603fc857aeea030526954290bfee18" => :el_capitan
    sha256 "f737693414e21b5ab9c434be4ffd5923fb4ccc153c4039ba2a65dea4f1010a95" => :yosemite
    sha256 "b87d487cb1a2d951d9b38c651dda2cc6f3161e183a2174d033f220c0b9bb2cda" => :mavericks
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
