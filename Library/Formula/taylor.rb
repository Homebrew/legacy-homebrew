class Taylor < Formula
  desc "Measure Swift code metrics and get reports in Xcode and Jenkins."
  homepage "https://github.com/yopeso/Taylor/"
  url "https://github.com/yopeso/Taylor/archive/0.1.2.tar.gz"
  sha256 "6d7c903c093e118d243e4ef58827f715133ba60aa3ea309c72cb92ae4c1e8624"
  head "https://github.com/yopeso/Taylor.git"

  bottle do
    cellar :any
    sha256 "b1f6569df01e41996bdd8176951b0aa5b6bf3f72a28fc0501ed3d4f8f83db323" => :el_capitan
    sha256 "89a80e4442f3518b09475d8dc8a47d497712e30d734cc9bbded5178a6a1aeaff" => :yosemite
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
