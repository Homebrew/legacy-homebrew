require 'formula'

class Fsbext < Formula
  homepage 'http://aluigi.altervista.org/papers.htm'
  url 'https://dl.dropbox.com/u/14604/fsbext.zip'
  md5 '5a1b911efe2e7c13b377f9007c587760'
  version '0.3'

  def install
    system "gcc fsbext.c -o fsbext"
    bin.install 'fsbext'
  end
  def patches
    # fixes strcasecmp
    DATA
  end

  def test
    system "which fsbext"
  end
end

__END__

diff --git a/fsbext.c b/fsbext.c
index e643fca..4cbe027 100755
--- a/fsbext.c
+++ b/fsbext.c
@@ -1978,7 +1978,7 @@ void put_extension(u8 *fname, u8 *ext, int skip_known) {
             experimental_extension_guessing(fname, oldext_buff, fname + strlen(fname));
             if(oldext_buff[0]) {
                 strcpy(wavext + 1, ext);
-            } else if(!stricmp(wavext + 1, ext)) {
+            } else if(!strcasecmp(wavext + 1, ext)) {
                 // do nothing
             } else {
                 sprintf(fname + strlen(fname), ".%s", ext);