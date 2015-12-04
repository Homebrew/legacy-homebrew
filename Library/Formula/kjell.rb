class Kjell < Formula
  desc "Erlang shell"
  homepage "https://karlll.github.io/kjell/"
  # clone repository in order to get extensions submodule
  url "https://github.com/karlll/kjell.git",
      :tag => "0.2.6",
      :revision => "0848ad2d2ddefc74774f0d793f4aebd260efb052"

  head "https://github.com/karlll/kjell.git"

  bottle do
    sha256 "7e7f90452ecf67a9016b1ba76ffcd17086864412f32caa424e202023a7a5377c" => :yosemite
    sha256 "729a73ae8920c3b25354da71c3d21ff797ed237e6636dd2adb648b80e44cc582" => :mavericks
    sha256 "0f8e9a9a31b9bea6227d27cf0aeebc31b925b3ac624314779086be8f943b4483" => :mountain_lion
  end

  depends_on "erlang"

  def install
    system "make"
    system "make", "configure", "PREFIX=#{prefix}"
    system "make", "install", "NO_SYMLINK=1"
    system "make", "install-extensions"
  end

  def caveats; <<-EOS.undent
    Extension 'kjell-prompt' requires a powerline patched font.
    See https://github.com/Lokaltog/powerline-fonts
    EOS
  end

  test do
    ENV["TERM"] = "xterm"
    system "script", "-q", "/dev/null", bin/"kjell", "-sanity_check", "true"
  end
end
