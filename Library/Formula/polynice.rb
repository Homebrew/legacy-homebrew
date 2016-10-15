class Polynice < Formula
  homepage "https://github.com/garabik/polynice"
  url "https://github.com/garabik/polynice/archive/v0.7.tar.gz"
  sha256 "7544a74203f77dc2b4a514052cf89fb5c9939e8fee0f06f52816b6a140defc07"

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
