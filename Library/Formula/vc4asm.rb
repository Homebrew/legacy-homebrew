class Vc4asm < Formula
  desc "Macro assembler for Broadcom VideoCore IV aka Raspberry Pi GPU"
  homepage "http://maazl.de/project/vc4asm/doc/index.html"
  url "https://github.com/maazl/vc4asm/archive/V0.2.1.tar.gz"
  sha256 "c9ffb315961a634cef1a26620a73483e7b819a963374952046aa7099d7ceb25c"

  bottle do
    cellar :any
    sha256 "61d33586464106166ab596587e9e568d966073f328830b96b895cbd0e7f387b7" => :yosemite
    sha256 "9a4abc2e869f51c8045468e7bc261ae5d863e9fd3eabefd797c898a88580bfc9" => :mavericks
    sha256 "8c78b6050331c1580dfe22a330a0e449a8b94e18d6432078668f08a2ffc99583" => :mountain_lion
  end

  needs :cxx11

  # Removes ELF support for OSX (merged upstream)
  patch do
    url "https://github.com/maazl/vc4asm/pull/7.patch"
    sha256 "50e8d58bf406aed69c8e247cb447353cc7a9fb6d5c6c7862c6447bf28a4c8779"
  end
  patch do
    url "https://github.com/maazl/vc4asm/commit/e2e855cd728f7f2eab45499dd251cf63db19c0cb.patch"
    sha256 "72aa18f016669cdafec927b917f951f30c3f8946f1e8a4df1fd0016c171fa6d4"
  end

  def install
    ENV.cxx11
    cd "src" do
      system "make"
    end
    bin.install %w[bin/vc4asm bin/vc4dis]
    share.install "share/vc4.qinc"
  end

  test do
    (testpath/"test.qasm").write <<-EOS.undent
      mov -, sacq(9)
      add r0, r4, ra1.unpack8b
      add.unpack8a r0, r4, ra1
      add r0, r4.8a, ra1
    EOS
    system "#{bin}/vc4asm", "-o test.hex", "-V", "#{share}/vc4.qinc", "test.qasm"
  end
end
