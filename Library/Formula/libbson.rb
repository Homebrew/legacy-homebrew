require "formula"

class Libbson < Formula
  homepage "https://github.com/mongodb/libbson"
  url "https://github.com/mongodb/libbson/releases/download/1.0.2/libbson-1.0.2.tar.gz"
  sha1 "20126faa95dfdcdc30d4289b82e914cc5b606be7"

  bottle do
    cellar :any
    revision 1
    sha1 "3297d100eaedf77809f91c51a7f72a73b593b933" => :yosemite
    sha1 "df8c11ab2248097d690e052f890658e357a16b59" => :mavericks
    sha1 "1f1dc1a0f7a196c8211a8e2fc1b3b2f69b58aefd" => :mountain_lion
  end

  def install
    system "./configure", "--enable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end
