class Titlecase < Formula
  desc "Script to convert text to title case"
  homepage "http://plasmasturm.org/code/titlecase/"
  url "https://github.com/ap/titlecase/archive/v1.001.tar.gz"
  sha256 "8619b1f9198ae6bcacf24b309830a2bb9d7a77a10d8d04d517855846153f7715"

  head "https://github.com/ap/titlecase.git"

  bottle :unneeded

  def install
    bin.install "titlecase"
  end

  test do
    (testpath/"test").write "homebrew"
    assert_equal "Homebrew\n", shell_output("#{bin}/titlecase test")
  end
end
