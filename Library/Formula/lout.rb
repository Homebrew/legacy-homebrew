require 'formula'

class Lout < Formula
  homepage 'http://savannah.nongnu.org/projects/lout'
  url 'http://download.savannah.gnu.org/releases/lout/lout-3.40.tar.gz'
  sha1 'adb7f632202319a370eaada162fa52cf334f40b3'

  def install
    inreplace "makefile" do |s|
      s.change_make_var! "PREFIX", prefix
      s.change_make_var! "LOUTLIBDIR", lib
      s.change_make_var! "LOUTDOCDIR", doc
      s.change_make_var! "MANDIR", man1
    end
    bin.mkpath
    man1.mkpath
    (doc/'lout').mkpath
    system "make allinstall"
  end
end
