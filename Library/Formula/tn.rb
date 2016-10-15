require "formula"

class Tn < Formula
  homepage "http://tony612.github.io/tn"
  url "https://github.com/tony612/tn/archive/v0.1.0.tar.gz"
  sha1 "1ff76eb4c917589157a71a5065feacf61753a342"

  head "https://github.com/tony612/tn.git"

  depends_on 'terminal-notifier'

  def install
    bin.install Dir['bin/*']
    prefix.install 'VERSION'
  end

  test do
    system "#{bin}/tn", "-v"
  end
end
