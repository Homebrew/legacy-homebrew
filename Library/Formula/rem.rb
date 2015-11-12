class Rem < Formula
  desc "Command-line tool to access OSX Reminders.app database"
  homepage "https://github.com/kykim/rem"
  url "https://github.com/kykim/rem/archive/20150618.tar.gz"
  sha256 "e57173a26d2071692d72f3374e36444ad0b294c1284e3b28706ff3dbe38ce8af"

  bottle do
    cellar :any
    sha256 "d9a6303ff3935923ba53d093e95387caaf24460a4cd7fb7d330fa5c3988b551c" => :yosemite
    sha256 "bf65e89ec4ca486b95f04c1c737627b2e0091af8a5c137795e521b96664d75e2" => :mavericks
    sha256 "3c858e09bce1941b84ca3e5d77163cac4e3b7efcd6a1afcc72354a450c8ee495" => :mountain_lion
  end

  depends_on :xcode => :build

  conflicts_with "remind", :because => "both install `rem` binaries"

  def install
    xcodebuild
    bin.install "build/Release/rem"
  end

  test do
    system "#{bin}/rem", "version"
  end
end
