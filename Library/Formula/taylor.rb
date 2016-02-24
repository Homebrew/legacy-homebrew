class Taylor < Formula
  desc "Measure Swift code metrics and get reports in Xcode and Jenkins."
  homepage "https://github.com/yopeso/Taylor/"
  url "https://github.com/yopeso/Taylor/archive/0.1.2.tar.gz"
  sha256 "6d7c903c093e118d243e4ef58827f715133ba60aa3ea309c72cb92ae4c1e8624"
  head "https://github.com/yopeso/Taylor.git"

  bottle do
    cellar :any
    sha256 "d8985bb008d9bc04d8f0ba1857389d13ce708e6df1fe13d9a3068ecc9128ecf6" => :el_capitan
    sha256 "5701b33481fea36eef1240eb9107c63f045d0138998476a30f9692dc3d6711f0" => :yosemite
  end

  depends_on :xcode => ["7.2.1", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}", "MAKE_SYMLINKS=no"
  end

  test do
    (testpath/"Test.swift").write <<-EOS.undent
    import Foundation

    struct Test {
        func doNothing(){

        }
    }
    EOS
    system "#{bin}/taylor", "-p", testpath
  end
end
