class Hh < Formula
  desc "Bash and zsh history suggest box"
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/releases/download/1.17/hh-1.17-src.tgz"
  sha256 "68eae9ecb022d3f492b85e1479d9b81e3b47b568b7714fd35e4e0fca50234c6e"

  bottle do
    cellar :any
    sha256 "ac98ac6b688292e6a10cf15fad9b7010dae97af3de8ead3b2c518aa8c6b74063" => :yosemite
    sha256 "cf97b8be45310c6c43f43c3c7f1d35b97ef9811bc20a5eb46d8a36e2d6823832" => :mavericks
    sha256 "947d41c44564edc123d5cefc16eadd4d9e54bcf9a8e07beb78f2807344b76c67" => :mountain_lion
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
