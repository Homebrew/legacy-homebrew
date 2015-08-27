class Speex < Formula
  desc "Audio codec designed for speech"
  homepage "http://speex.org"
  url "http://downloads.xiph.org/releases/speex/speexdsp-1.2rc3.tar.gz"
  sha256 "4ae688600039f5d224bdf2e222d2fbde65608447e4c2f681585e4dca6df692f1"

  bottle do
    cellar :any
    sha1 "035c405657c5debb5e41d291bb44f508797a7b51" => :yosemite
    sha1 "123e086d2548614ff66691f46e6f6e3dce3fa362" => :mavericks
    sha1 "d9cb07f7de4d226c25d0b8ddbddd3fb0de5f5c53" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libogg" => :recommended

  def install
    ENV.j1
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}"]

    system "./configure", *args
    system "make", "install"
  end
end
