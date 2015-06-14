class Kjell < Formula
  desc "Erlang shell"
  homepage "https://karlll.github.io/kjell/"
  # clone repository in order to get extensions submodule
  url "https://github.com/karlll/kjell.git",
      :tag => "0.2.5",
      :revision => "42e2b68742533181fc1da868cceca2efb88bf3f4"

  head "https://github.com/karlll/kjell.git"

  bottle do
    sha256 "a192455ff56b71352922c12cb7bc5c8d13fb0957379414170a6cd87e8294a275" => :yosemite
    sha256 "c9cf3b4d1ef5785036e9752ae104357e701f4d56d7b330c41e9421cf63f4a3c8" => :mavericks
    sha256 "d87338b3f6669d917ce0202da53cb0737e6c67b9295d29f5efd55b0aa50574a3" => :mountain_lion
  end

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
