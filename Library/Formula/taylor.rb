class Taylor < Formula
  desc "Measure Swift code metrics and get reports in Xcode and Jenkins."
  homepage "https://github.com/yopeso/Taylor/"
  url "https://github.com/yopeso/Taylor/archive/0.1.1.tar.gz"
  sha256 "0fd11aeed6d99bf76dbad9359d706db4ff62450f7903474771c36fd6c5e6f0a7"
  head "https://github.com/yopeso/Taylor.git"

  bottle do
    cellar :any
    sha256 "b1f6569df01e41996bdd8176951b0aa5b6bf3f72a28fc0501ed3d4f8f83db323" => :el_capitan
    sha256 "89a80e4442f3518b09475d8dc8a47d497712e30d734cc9bbded5178a6a1aeaff" => :yosemite
  end

  depends_on :xcode => ["7.2", :build]

  def install
    system "make", "install_homebrew", "PREFIX=#{prefix}"
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
