require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Sdcv < Formula
  homepage 'http://sdcv.sourceforge.net/'
  url 'https://sdcv.svn.sourceforge.net/svnroot/sdcv/trunk', :revision => '38'
  version '0.4.3'

  depends_on 'pkg-config' => :build
  depends_on 'automake' => :build
  depends_on 'glib'
  depends_on 'gettext'
  depends_on 'readline'

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      only llvm work, use `brew install --llvm sdcv`
      EOS
  end

  def patches
    { :p0 => "https://trac.macports.org/export/100327/trunk/dports/textproc/sdcv/files/patch-setlocale.diff" }
  end

  def install
    system "autoreconf"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end
end
