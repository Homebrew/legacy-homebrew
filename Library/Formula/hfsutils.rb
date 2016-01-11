class Hfsutils < Formula
  desc "Tools for reading and writing Macintosh volumes"
  homepage "http://www.mars.org/home/rob/proj/hfs/"
  url "ftp://ftp.mars.org/pub/hfs/hfsutils-3.2.6.tar.gz"
  sha256 "bc9d22d6d252b920ec9cdf18e00b7655a6189b3f34f42e58d5bb152957289840"

  bottle do
    cellar :any
    sha256 "2d0997b77b2bc7b3a0454c552c6ebd3b24c6efc01bc9e4814781f7971c8802f9" => :yosemite
    sha256 "06dddcb4d540a24b63b389213724b828f99bfc7c32272be1a9e4ca4472409c93" => :mavericks
    sha256 "251b45cb10a8c3ea4d543cd0a843acd266e4acd01637f7f999e8221324835e19" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    bin.mkpath
    man1.mkpath
    system "make", "install"
  end

  test do
    system "dd", "if=/dev/zero", "of=disk.hfs", "bs=1k", "count=800"
    system bin/"hformat", "-l", "Test Disk", "disk.hfs"
    output = shell_output("#{bin}/hmount disk.hfs")
    assert_match /^Volume name is "Test Disk"$/, output
    assert_match /^Volume has 803840 bytes free$/, output
  end
end
