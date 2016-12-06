require 'formula'

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
    system "sc"
  end
end
