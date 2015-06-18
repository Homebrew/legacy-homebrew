class Rem < Formula
  desc "Command-line tool to access OSX Reminders.app database"
  homepage "https://github.com/kykim/rem"
  url "https://github.com/kykim/rem/archive/20150618.tar.gz"
  # version "20150618"
  sha256 "e57173a26d2071692d72f3374e36444ad0b294c1284e3b28706ff3dbe38ce8af"

  depends_on :macos => :mountain_lion
  depends_on :xcode

  def install
    xcodebuild "-project", "rem.xcodeproj",
               "-target", "rem",
               "SYMROOT=build",
               "DSTROOT=#{prefix}",
               "INSTALL_PATH=/bin",
               "-verbose",
               "install"
  end

  test do
    system "true"
  end
end
