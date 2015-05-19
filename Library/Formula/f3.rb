class F3 < Formula
  desc "Test various flash cards"
  homepage "http://oss.digirati.com.br/f3/"
  url "https://github.com/AltraMayor/f3/archive/v5.0.tar.gz"
  sha1 "be28f55ea8450a388a0ea63dc1f810080d822d22"

  head "https://github.com/AltraMayor/f3.git"

  bottle do
    cellar :any
    sha1 "60c3eabb3069d9aca853a8e9a482b7922499dc56" => :yosemite
    sha1 "e79ac68956f2b72bd76dbb8a359a75da12ed85fe" => :mavericks
    sha1 "2407d28f6497df41aa5784e1cd0153d3fc8214c7" => :mountain_lion
  end

  def install
    system "make", "all"
    bin.install %w[f3read f3write]
    man1.install "f3read.1"
    man1.install_symlink "f3read.1" => "f3write.1"
  end

  test do
    system "#{bin}/f3read", testpath
  end
end
