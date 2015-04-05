class Polynice < Formula
  homepage "https://github.com/garabik/polynice"
  url "https://github.com/garabik/polynice/archive/v0.7.tar.gz"
  sha256 "9b12c27f530e5893c54aa41d95f1da3dba40310060e9bf634f5df4368e65a504"

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
