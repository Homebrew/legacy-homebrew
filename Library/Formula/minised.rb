class Minised < Formula
  desc "Smaller, cheaper, faster SED implementation"
  homepage "https://www.exactcode.com/opensource/minised/"
  url "https://dl.exactcode.de/oss/minised/minised-1.15.tar.gz"
  sha256 "ada36a55b71d1f2eb61f2f3b95f112708ce51e69f601bf5ea5d7acb7c21b3481"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "4f33f6d39c9190899cf04857f70481ffd57996daf5001cad661ae0ea7f002a88" => :el_capitan
    sha256 "d169d87a77fe06c1190065e502e84fc3f3b3714cdc98a1235c78033a41e6a292" => :yosemite
    sha256 "505d4a7dcb7deeef34344f72b7c7801f90e2c38393add6e2bc41a6434c3fd899" => :mavericks
  end

  def install
    system "make"
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
  end

  test do
    output = pipe_output("#{bin}/minised 's:o::'", "hello world", 0)
    assert_equal "hell world", output.chomp
  end
end
