require "formula"

class LogNotifier < Formula
  homepage "https://github.com/nocturnalfrog/log-notifier"
  head "https://github.com/nocturnalfrog/log-notifier.git"
  url "https://github.com/nocturnalfrog/log-notifier/archive/v0.3.tar.gz"
  sha1 "5d508a51c52cb0fa44cd90901cb71f8d56109b2e"

  def install
    bin.install "log-notifier"
  end

  # Adding dependencies
  depends_on :macos => :lion # Needs at least Mac OS X "Lion" aka. 10.7.
  depends_on "terminal-notifier"
  depends_on "fswatch"

  test do
    system bin/"log-notifier", "--test"
  end
end
