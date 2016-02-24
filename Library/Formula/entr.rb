class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "http://entrproject.org/"
  url "http://entrproject.org/code/entr-3.4.tar.gz"
  mirror "https://bitbucket.org/eradman/entr/get/entr-3.4.tar.gz"
  sha256 "ce7d000fd6f2b711df905e9a6d8a2a0f50026ebaf34afeb9132d52617b6e010a"

  bottle do
    cellar :any_skip_relocation
    sha256 "611108cae6c65bc9de49af576b75df2b7208292f7e90ecc57b95737ac56b0729" => :el_capitan
    sha256 "26c226b9f35e33ead67ad1318e88583d0ba8cabed58e945a266750e34f967c0f" => :yosemite
    sha256 "143ed2772f5f62a56a0066c4cbf41af5b1b5cdd89e2900f4a867b0e039cfe943" => :mavericks
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
