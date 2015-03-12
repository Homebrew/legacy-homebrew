class Entr < Formula
  homepage "http://entrproject.org/"
  url "http://entrproject.org/code/entr-3.1.tar.gz"
  mirror "https://bitbucket.org/eradman/entr/get/entr-3.1.tar.gz"
  sha256 "f0f27e8fc610936f5ec72891687fc77e0df0b21172f14e85ff381d2fe5e3aadd"

  bottle do
    cellar :any
    sha256 "542fb9bb0afac1abf0cf0ab2453f2306dae13c16f49acfd4f0b9d0bfbb3d4fdd" => :yosemite
    sha256 "63067a6f69ff0f08e11051122d90c3aa6e6725546541149015d905b14296812f" => :mavericks
    sha256 "1e5079627fddee8edb06f74153ad6de06d507032467b8ecfc241c28a943b740e" => :mountain_lion
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
    assert_equal "New File", pipe_output("#{bin}/entr -d echo 'New File'", testpath).strip
  end
end
