class Kjell < Formula
  homepage "https://karlll.github.io/kjell/"
  # clone repository in order to get extensions submodule
  url "https://github.com/karlll/kjell.git",
      :tag => "0.2.5",
      :revision => "42e2b68742533181fc1da868cceca2efb88bf3f4"

  head "https://github.com/karlll/kjell.git"

  depends_on "erlang"

  def install
    system "make"
    system "make", "configure", "PREFIX=#{prefix}"
    system "make", "install", "NO_SYMLINK=1"
    system "make", "install-extensions"
  end

  def caveats
    "Extension 'kjell-prompt' requires a powerline patched font. See https://github.com/Lokaltog/powerline-fonts"
  end
end
