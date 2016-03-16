class Sourcekittendaemon < Formula
  desc "Swift Auto Completions for any Text Editor"
  homepage "https://github.com/terhechte/SourceKittenDaemon"
  url "https://github.com/terhechte/SourceKittenDaemon.git",
    :tag => "0.1.3",
    :revision => "c848558a39ddd685a525bb4ab2b2e5fb95d577b2",
    :shallow => false
  head "https://github.com/terhechte/SourceKittenDaemon.git"

  depends_on :xcode => ["7.1", :build]
  depends_on "carthage" => :build

  def install
    system "carthage", "build", "--platform", "Mac"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    command = "#{bin}/sourcekittendaemon start 2>&1"
    expectation = "Please provide a project"
    assert_match expectation, shell_output(command, 1)
  end
end
