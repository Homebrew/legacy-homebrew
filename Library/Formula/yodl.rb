class Yodl < Formula
  homepage "http://yodl.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/yodl/yodl/3.05.01/yodl_3.05.01.orig.tar.gz"
  sha256 "5a3d0e1b2abbba87217cfdc6cd354a00df8d782572495bbddbdfbd4f47fe0d3e"

  depends_on "ghostscript"
  depends_on "icmake"

  depends_on :tex => :optional

  def install
    inreplace 'INSTALL.im', /"\/usr"/, "\"#{prefix}\""
    inreplace 'build', /\/usr\/bin\/icmake/, "#{Formula["icmake"].opt_bin}/icmake"

    inreplace 'icmake/install', /run\("cp " \+ g_install \+ BIN/, 'run("cp -R " + g_install + BIN'

    system "./build", "programs"
    system "./build", "macros"
    system "./build", "man"

    system "./build", "install", "programs"
    system "./build", "install", "macros"
    system "./build", "install", "man"
    if build.with? "tex"
      system "./build", "manual"
      system "./build", "install", "manual"
    end
    system "./build", "install", "programs"
  end
end

