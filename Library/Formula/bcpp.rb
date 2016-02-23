class Bcpp < Formula
  desc "C(++) beautifier"
  homepage "http://invisible-island.net/bcpp/"
  url "ftp://invisible-island.net/bcpp/bcpp-20131209.tgz"
  sha256 "4732d606c9b5857d0ea2cee2f2b54eb3b8928f547f8a0c6b89096b674c6bd7f7"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9cbefdb72acc228f8e31afc7d6dabf3dcc1fac321aa88cd0834687afd15c9d1" => :el_capitan
    sha256 "55695704fc182a79be6761a720b18c0be3f416ef2602ea0048c8f2a00422bfa9" => :yosemite
    sha256 "5a8b1bf857e52ca6b30c4ef31547b23d807364075aec50a47c7ce16fdfc8b59d" => :mavericks
    sha256 "5cbc5e640e0c8ebcfeee4091364855bd0f67a54663a819a9f875f648e7cb48b9" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
    etc.install "bcpp.cfg"
  end

  test do
    (testpath/"test.txt").write <<-EOS.undent
              test
                 test
          test
                test
    EOS
    system bin/"bcpp", "test.txt", "-fnc", "#{etc}/bcpp.cfg"
    assert File.exist?("test.txt.orig")
    assert File.exist?("test.txt")
  end
end
