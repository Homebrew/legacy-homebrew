class Newt < Formula
  desc "Library for color text mode, widget based user interfaces"
  homepage "https://fedorahosted.org/newt/"
  url "https://fedorahosted.org/releases/n/e/newt/newt-0.52.18.tar.gz"
  sha256 "771b0e634ede56ae6a6acd910728bb5832ac13ddb0d1d27919d2498dab70c91e"

  bottle do
    cellar :any
    sha256 "33403d77594cecec7efb68b21a3a55b0c2510cd3c97d8aa5f252015632c5962b" => :yosemite
    sha256 "d1a3b95da1718bae9461c958cc05b739f94ee4ec0e5d08f7a8001cd29aa82dc8" => :mavericks
    sha256 "ace3c7f7beacda4039b3d147687214a01f6006a6d53eadbb245825a2cea402ad" => :mountain_lion
  end

  depends_on "gettext"
  depends_on "popt"
  depends_on "s-lang"
  depends_on :python => :optional

  # build dylibs with -dynamiclib; version libraries
  # Patch via MacPorts
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/0eb53878/newt/patch-Makefile.in.diff"
    sha256 "6672c253b42696fdacd23424ae0e07af6d86313718e06cd44e40e532a892db16"
  end

  def install
    args = ["--prefix=#{prefix}", "--without-tcl"]
    args << "--without-python" if build.without? "python"

    inreplace "Makefile.in" do |s|
      # name libraries correctly
      # https://bugzilla.redhat.com/show_bug.cgi?id=1192285
      s.gsub! "libnewt.$(SOEXT).$(SONAME)", "libnewt.$(SONAME).dylib"
      s.gsub! "libnewt.$(SOEXT).$(VERSION)", "libnewt.$(VERSION).dylib"

      # don't link to libpython.dylib
      # causes https://github.com/Homebrew/homebrew/issues/30252
      # https://bugzilla.redhat.com/show_bug.cgi?id=1192286
      s.gsub! "`$$pyconfig --ldflags`", '"-undefined dynamic_lookup"'
      s.gsub! "`$$pyconfig --libs`", '""'
    end

    system "./configure", *args
    system "make", "install"
  end
end
