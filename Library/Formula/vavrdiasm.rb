class Vavrdiasm < Formula
  desc "8-bit Atmel AVR disassembler"
  homepage "https://github.com/vsergeev/vAVRdisasm"
  url "https://github.com/vsergeev/vavrdisasm/archive/v3.1.tar.gz"
  sha256 "4fe5edde40346cb08c280bd6d0399de7a8d2afdf20fb54bf41a8abb126636360"

  bottle do
    cellar :any
    sha1 "3cd688a816ee9f7a4046db6170e8d42467877ee5" => :yosemite
    sha1 "840d8e147085e86941da55763625d82e44b2ca79" => :mavericks
    sha1 "5ce2eed553cbe8e522b29106eda55b559ce55ac5" => :mountain_lion
  end

  # Patch:
  # - BSD `install(1)' does not have a GNU-compatible `-D' (create intermediate
  #   directories) flag. Switch to using `mkdir -p'.
  # - Make `PREFIX' overridable
  #   https://github.com/vsergeev/vavrdisasm/pull/2
  patch :DATA

  def install
    ENV["PREFIX"] = prefix
    system "make"
    system "make", "install"
  end

  test do
    # Code to generate `file.hex':
    ## .device ATmega88
    ##
    ## LDI     R16, 0xfe
    ## SER     R17
    #
    # Compiled with avra:
    ## avra file.S && mv file.S.hex file.hex

    (testpath/"file.hex").write <<-EOS.undent
      :020000020000FC
      :040000000EEF1FEFF1
      :00000001FF
    EOS

    output = `vavrdisasm file.hex`.lines.to_a

    assert output[0].match(/ldi\s+R16,\s0xfe/).length == 1
    assert output[1].match(/ser\s+R17/).length == 1
  end
end

__END__
diff --git a/Makefile b/Makefile
index 3b61942..f1c94fc 100644
--- a/Makefile
+++ b/Makefile
@@ -1,5 +1,5 @@
 PROGNAME = vavrdisasm
-PREFIX = /usr
+PREFIX ?= /usr
 BINDIR = $(PREFIX)/bin

 ################################################################################
@@ -35,7 +35,8 @@ test: $(PROGNAME)
 	python2 crazy_test.py

 install: $(PROGNAME)
-	install -D -s -m 0755 $(PROGNAME) $(DESTDIR)$(BINDIR)/$(PROGNAME)
+	mkdir -p $(DESTDIR)$(BINDIR)
+	install -s -m 0755 $(PROGNAME) $(DESTDIR)$(BINDIR)/$(PROGNAME)

 uninstall:
 	rm -f $(DESTDIR)$(BINDIR)/$(PROGNAME)
