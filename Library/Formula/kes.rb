class Kes < Formula
  desc "Fork of the es shell based on the rc command interpreter"
  homepage "https://github.com/epilnivek/kes"
  url "https://github.com/epilnivek/kes/archive/v0.9.tar.gz"
  sha256 "d0db16ba7892d9692cacd552d684f03a9d0333ba0e7b629a998fa9c127ef050e"

  head "https://github.com/epilnivek/kes.git"

  bottle do
    cellar :any
    sha256 "84db02dd57749a28718482893d9c032c7056ddc32ea9d305d38172ca14199c80" => :yosemite
    sha256 "b07636ad0d38972397fcc64059b2e5505110400415e41ff0417ecccb71fcff38" => :mavericks
    sha256 "a736dd5aa01f8a8011f6a05fe82ba43954fdf0f3037e483c96bfda9ee7591c48" => :mountain_lion
  end

  depends_on "readline"

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
