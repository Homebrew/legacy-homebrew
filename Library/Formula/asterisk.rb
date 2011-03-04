require 'formula'

class Asterisk <Formula
  url 'http://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-1.6.1.6.tar.gz'
  homepage 'http://www.asterisk.org/'
  md5 '63a928373e741524aac09d8c078df7d5'

  def patches
    DATA
  end

  def install
    configure_flags = [ "--prefix=#{prefix}", "--localstatedir=#{var}", "--sysconfdir=#{etc}" ]
    # Avoid "src/add.c:1: error: CPU you selected does not support x86-64 instruction set"
    configure_flags << "--host=x86_64-darwin" if snow_leopard_64?
    system "./configure", *configure_flags
    system "make"
    system "make install"
    (etc+"asterisk").mkpath
  end
end


# Use cURL instead of wget
__END__
--- a/sounds/Makefile	2009-10-13 02:12:08.000000000 +0300
+++ b/sounds/Makefile	2009-10-13 02:15:11.000000000 +0300
@@ -53,10 +53,8 @@
 MM:=$(subst -SLN16,-sln16,$(MM))
 MOH:=$(MM:MOH-%=asterisk-moh-%.tar.gz)
 MOH_TAGS:=$(MM:MOH-%=$(MOH_DIR)/.asterisk-moh-%)
-# If "fetch" is used, --continue is not a valid option.
-ifeq ($(WGET),wget)
-WGET_ARGS:=--continue
-endif
+DOWNLOAD:=curl
+WGET_ARGS:=-O
 
 all: $(CORE_SOUNDS) $(EXTRA_SOUNDS) $(MOH)
 
