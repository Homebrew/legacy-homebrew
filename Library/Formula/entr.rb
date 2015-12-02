class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "http://entrproject.org/"
  url "http://entrproject.org/code/entr-3.3.tar.gz"
  mirror "https://bitbucket.org/eradman/entr/get/entr-3.3.tar.gz"
  sha256 "701cb7b0a72b6c9ba794ad7cc15b6ebcc2e0c978bb6906c8ae407567a044461f"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "8bd2c5ee9826218a7b6ed66398a40f8f4516ce6cf64bf39d78a88fbb6f82c71a" => :el_capitan
    sha256 "a1ba1bce58f151292922500142e7166120a2cb572d0b7fb08a81ee501e841698" => :yosemite
    sha256 "5284c5f631a02c76411453667f401793292fee0304e3727422fcc8efdedd2f85" => :mavericks
  end

  head do
    url "https://bitbucket.org/eradman/entr", :using => :hg
    depends_on :hg => :build
  end

  def install
    ENV["PREFIX"] = prefix
    ENV["MANPREFIX"] = man
    system "./configure"
    system "make"
    system "make", "install"
  end

  test do
    touch testpath/"test.1"
    fork do
      sleep 0.5
      touch testpath/"test.2"
    end
    assert_equal "New File", pipe_output("#{bin}/entr -p -d echo 'New File'", testpath).strip
  end
end
