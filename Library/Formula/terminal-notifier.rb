require 'formula'

class TerminalNotifier < Formula
  homepage 'https://github.com/alloy/terminal-notifier'
  url 'https://github.com/downloads/alloy/terminal-notifier/terminal-notifier_1.4.2.zip'
  sha1 'aaf27d82d237c3f4f7c7ffe2e7118dd2552d6e8a'

  def install
    # Write an executable script to call the app bundles' inner binary
    # See the developers' note on the matter in the project README:
    # https://github.com/alloy/terminal-notifier/blob/master/README.markdown
    prefix.install Dir['*']
    inner_binary = "#{prefix}/terminal-notifier.app/Contents/MacOS/terminal-notifier"
    bin.write_exec_script inner_binary
    chmod 0755, Pathname.new(bin+"terminal-notifier")
  end

  test do
    # Display a test notice
    system "#{bin}/terminal-notifier", \
      "-title",     "Homebrew", \
      "-subtitle",  "Test CLI Notification", \
      "-message",   "Run terminal-notifier (sans args) for usage info", \
      "-activate",  "com.apple.UserNotificationCenter"
      # We bind the notices' click event to a NOP, essentially,
      # by stipulating the ID of the notice widget's own app bundle
      # as that which it should 'activate'.
  end
end
