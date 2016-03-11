class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "http://modules.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-3.2.10/modules-3.2.10.tar.bz2"
  sha256 "e8403492a8d57ace6485813ad6cdaafe0a735b7d93b9435553a8d11d3fdd29a2"

  bottle do
    sha256 "a33a62060774cb6bf433653771cd5069a308ba6fe86daceeee044f4e5dd6a745" => :el_capitan
    sha256 "62203b2abd9c20f31dd3e29da16bc0c27bc404b68beaa8f0bdce491c6f261e89" => :yosemite
    sha256 "d46c87889814f42b07e22b634061a899baac9a49191cb049c8eb3c91ad3650bc" => :mavericks
  end

  depends_on :x11 => :optional

  def install
    # -DUSE_INTERP_ERRORLINE fixes
    # error: no member named 'errorLine' in 'struct Tcl_Interp'
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --datarootdir=#{share}
      --disable-versioning
      CPPFLAGS=-DUSE_INTERP_ERRORLINE]
    args << "--without-x" if build.without? "x11"
    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    To activate modules, add the following at the end of your .zshrc:
      source #{opt_prefix}/Modules/init/zsh
    You will also need to reload your .zshrc:
      source ~/.zshrc
    EOS
  end

  test do
    system *%W[#{prefix}/Modules/bin/modulecmd --version]
    system "zsh", "-c", "source #{prefix}/Modules/init/zsh; module"
  end
end
