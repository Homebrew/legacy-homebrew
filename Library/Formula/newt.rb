class Newt < Formula
  homepage 'https://fedorahosted.org/newt/'
  url 'https://fedorahosted.org/releases/n/e/newt/newt-0.52.18.tar.gz'
  sha1 '2992c926bd3699ff0d6fd7549d4a8a018e3ac8fd'

  depends_on 'gettext'
  depends_on 'popt'
  depends_on 's-lang'
  depends_on :python => :optional

  # build dylibs with -dynamiclib; version libraries
  patch :p0 do
    url "https://trac.macports.org/export/132914/trunk/dports/devel/libnewt/files/patch-Makefile.in.diff"
    sha1 "f366a650ed100317344a3e7f49981a6dca1f4889"
  end

  def install
    args = ["--prefix=#{prefix}", "--without-tcl"]
    args << "--without-python" if build.without? 'python'

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
