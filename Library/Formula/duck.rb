require "formula"

class Duck < Formula
  homepage "https://duck.sh/"
  # Reference to the CLI version of Cyberduck
  url "https://update.cyberduck.io/cli//duck-4.6.2.16269.tar.gz"
  version "4.6.2.16269"
  sha1 "c417af3c8069ac5a3dc58329eaf2323234925cb5"

  def install
    # Because compiling would need a JDK and xcodebuild we just use the pre-compiled binary.
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/Contents/MacOS/duck" => "duck"
  end

  test do
    system "#{bin}/duck", "-version"
  end

  def caveats;
    <<-EOS.undent
    For more information refer to https://duck.sh/
    EOS
  end
end
