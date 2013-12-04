require 'formula'

class Gabedit < Formula
  homepage 'http://gabedit.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/gabedit/gabedit/Gabedit240/GabeditSrc240.tar.gz'
  version '2.4.0'
  sha1 '9c53590051da363f419a6b746594bf9f9aa92737'

  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on 'gtkglext'

  def install
    args = []
    args << "OMPLIB=" << "OMPCFLAGS=" if ENV.compiler == :clang
    system 'make', *args
    bin.install 'gabedit'
  end
end
