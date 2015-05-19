class Shtool < Formula
  desc "GNU's portable shell tool"
  homepage "https://www.gnu.org/software/shtool/"
  url "http://ftpmirror.gnu.org/shtool/shtool-2.0.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/shtool/shtool-2.0.8.tar.gz"
  sha256 "1298a549416d12af239e9f4e787e6e6509210afb49d5cf28eb6ec4015046ae19"

  bottle do
    cellar :any
    sha256 "de69e23a1e88799c78891298045bd8f79ef67ee48b7609fa065c7acdc1ddbde4" => :yosemite
    sha256 "14b7ea00fce6bf6df8e684f1f4db589ad4f6bc7051a4a29f34d51fb6d287d0a9" => :mavericks
    sha256 "6e46064ddebb9f3510fb8f8e3b5f48b7f931004334cffba5a3b65cc49588e3a2" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "Hello World!", pipe_output("#{bin}/shtool echo 'Hello World!'").chomp
  end
end
