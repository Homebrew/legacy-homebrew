require 'formula'

class Pev < Formula
  homepage 'http://pev.sourceforge.net/'
  url 'https://github.com/merces/pev/tarball/v0.50'
  sha1 '03ca75ac004946b463a37837870e43809113bf8a'

  def install
    # Fix:
    #   hardcoded gcc
    #   build dylibs instead
    #   don't put symlinks in ./lib/
    inreplace 'configure' do |f|
      f.gsub! "new_cc=\'gcc\'", "new_cc='#{ENV.cc}'"
      f.gsub! "replace \"s/^CC=.*/CC=$new_cc/\" \"$makef_libpe\"", "replace \"s!^CC=.*!CC=$new_cc!\" \"$makef_libpe\""
      f.gsub! "replace \"s/^CC=.*/CC=$new_cc/\" \"$makef_pev\"", "replace \"s!^CC=.*!CC=$new_cc!\" \"$makef_pev\""
      f.gsub! "new_libpe='-shared -Wl,-install_name,$(LIBNAME).so.1 -o $(LIBNAME).so $(LIBNAME).o'", "new_libpe='-dynamiclib -Wl,-install_name,$(LIBNAME).dylib -o $(LIBNAME).dylib $(LIBNAME).o'"
    end

    inreplace 'lib/libpe/Makefile' do |f|
      f.gsub! "$(LN) $(DEST)/$(LIBNAME).so.$(VERSION) $(DEST)/$(LIBNAME).so.1", "# no more symlink"
      f.gsub! "$(LN) $(DEST)/$(LIBNAME).so.$(VERSION) $(DEST)/$(LIBNAME).so", "# no more symlink"
      f.gsub! "$(INSTALL) $(LIBNAME).so $(DEST)/$(LIBNAME).so.$(VERSION)", "$(INSTALL) $(LIBNAME).so $(DEST)/$(LIBNAME).so"
      f.gsub! "$(LIBNAME).so","$(LIBNAME).dylib"
      f.gsub! "$(RM) $(LIBNAME).*o*", "$(RM) $(LIBNAME).*o* $(LIBNAME).dylib"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/pescan -v"
  end
end
