require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Sc < Formula
  homepage 'http://www.boutell.com/lsm/lsmbyid.cgi/000293'
  url 'ftp://metalab.unc.edu/pub/Linux/apps/financial/spreadsheet/sc-7.16.tar.gz'
  version '7.16'
  sha1 '33c77561fbbecc7fa3cf0d62ce244172edd0de3d'

  def install
    lib.mkpath
    man1.mkpath
    bin.mkpath

    inreplace  "Makefile", 'prefix=/usr', "prefix=#{prefix}"
    inreplace  "Makefile", 'install: $(EXDIR)/$(name) $(EXDIR)/$(name)qref $(EXDIR)/p$(name) \
	 $(LIBDIR)/tutorial $(MANDIR)/$(name).$(MANEXT) \
	 $(MANDIR)/p$(name).$(MANEXT)', 'install: $(EXDIR)/$(name) $(EXDIR)/$(name)qref $(EXDIR)/p$(name) \
	 $(LIBDIR)/tutorial'
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test sc`.
    system "sc"
  end
end
