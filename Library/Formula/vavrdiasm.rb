class Vavrdiasm < Formula
  desc "8-bit Atmel AVR disassembler"
  homepage "https://github.com/vsergeev/vAVRdisasm"
  url "https://github.com/vsergeev/vavrdisasm/archive/v3.1.tar.gz"
  sha256 "4fe5edde40346cb08c280bd6d0399de7a8d2afdf20fb54bf41a8abb126636360"

  bottle do
    cellar :any
    sha256 "ce57062586ca9cb91290141376f1da1f5de3c6efb6fe4687585a3e64cc29c014" => :yosemite
    sha256 "f881c5a6d94581c4fc9efb13118c84c40700f13d130302f6ee4cb16968d1f6b0" => :mavericks
    sha256 "d3866a89762e6d98987128b3e961788d1f997b1851b8b35213a9bb7ce3f53f39" => :mountain_lion
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
