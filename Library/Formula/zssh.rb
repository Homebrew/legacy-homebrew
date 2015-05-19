class Zssh < Formula
  desc "Interactive file transfers over SSH"
  homepage "http://zssh.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/zssh/zssh/1.5/zssh-1.5c.tgz"
  sha256 "a2e840f82590690d27ea1ea1141af509ee34681fede897e58ae8d354701ce71b"

  bottle do
    cellar :any
    sha256 "94280569f9e1c1deb9d8c3be4256cd501399fd51758f8e2ea6d77fd9f1b6ef2e" => :yosemite
    sha256 "94b16bb29616a839134527fd869ac40a8fb5fa88b0048d1a93a828e306c2a270" => :mavericks
    sha256 "e81d8a0d4c8107898aff0cda9abbf4a2caaf098f16c37bd92aa168943c7e6554" => :mountain_lion
  end

  depends_on "lrzsz"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"

    bin.install "zssh", "ztelnet"
    man1.install "zssh.1", "ztelnet.1"
  end
end
