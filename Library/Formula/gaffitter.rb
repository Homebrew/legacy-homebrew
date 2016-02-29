class Gaffitter < Formula
  desc "Efficiently fit files/folders to fixed size volumes (like DVDs)"
  homepage "http://gaffitter.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gaffitter/gaffitter/1.0.0/gaffitter-1.0.0.tar.gz"
  sha256 "c85d33bdc6c0875a7144b540a7cce3e78e7c23d2ead0489327625549c3ab23ee"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ca49d04fb786415d210d04e59c9e7ab74ada5ed6e2d429eb5793a3f34ba3562" => :el_capitan
    sha256 "66332311c91a27aaf93d9bfa9d8d7c7c373aad98eb80ff53efebd3b9a0c51ff7" => :yosemite
    sha256 "be06c31a5074d00dbf23ef22f515a8f42855aebdf0f9ee1a592c0a2581ff8279" => :mavericks
    sha256 "d5e388d425fffcc44e782f892f433774d93b874a432ad6439866dff048f1c60b" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"fit", "-t", "10m", "--show-size", testpath
  end
end
