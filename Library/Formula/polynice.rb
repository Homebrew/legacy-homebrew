class Polynice < Formula
  homepage "https://github.com/garabik/polynice"
  url "https://github.com/garabik/polynice/archive/master.tar.gz"
  version "0.7"

  depends_on "python3"

  def install
    inreplace "polynice", "#!/usr", "#!#{HOMEBREW_PREFIX}"
    man1.install "polynice.1"
    bin.install "polynice"
  end

  test do
    system "#{bin}/polynice", "-a", "-n", "1/1", "true"
  end
end
