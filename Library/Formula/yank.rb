class Yank < Formula
  desc "Yank terminal output to clipboard"
  homepage "https://github.com/mptre/yank"
  url "https://github.com/mptre/yank/archive/v0.4.0.tar.gz"
  sha256 "1adf1b07f7cb9401daeed7a05bad492db8ed77ead4728d9b45f541d56bc2e8c5"

  def install
    system "make", "install", "YANKCMD=pbcopy"
  end

  test do
    system "echo halp"
    # I'm unsure of how to write a test for an interactive program.
    #
    # ideally, we'd do `echo a b c | yank | cat` and somehow make yank select, for example, the 'b'
    # by moving one step to the right (CTRL-P) and selecting (ENTER). I don't know how to send those
    # interactive instructions to the program however.
  end
end
