require "formula"

class Sbagen < Formula
  homepage "http://uazu.net/sbagen/"
  url "http://uazu.net/sbagen/sbagen-1.4.5.tgz"
  sha1 "83fee62bd74fa19ccd46eebd2ad5de7744a78610"

  patch :DATA

  resource "river" do
    url "http://uazu.net/sbagen/sbagen-river-1.4.1.tgz"
    sha1 "7f9d497780798762ced2f6e89e2f52d06da26423"
  end

  def install
    system "./mk-macosx"

    bin.install "sbagen"
    doc.install Dir["*.txt"]

    sbagen_share = share + "sbagen"
    sbagen_share.install "examples", "scripts"
    resource("river").stage { sbagen_share.install Dir["*"] }
  end

  test do
    File.open("test.sbg", "w") do |file|
      file.write <<-EOS.undent
        -SE
        silent: -
        0:00:00 == silent
        0:00:01 == silent
      EOS
    end
    system "#{bin}/sbagen", "test.sbg"
  end

  def caveats
    <<-EOS.undent
      The examples, scripts, and loopable river sounds have been installed to:
        #{HOMEBREW_PREFIX}/share/sbagen
    EOS
  end
end

__END__
--- a/sbagen.c
+++ b/sbagen.c
@@ -149,7 +149,7 @@
  #include <mmsystem.h>
 #endif
 #ifdef MAC_AUDIO
- #include <Carbon.h>
+ #include <Carbon/Carbon.h>
  #include <CoreAudio/CoreAudio.h>
 #endif
 #ifdef UNIX_TIME
