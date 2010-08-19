require 'formula'

class Streamripper <Formula
  url 'http://downloads.sourceforge.net/sourceforge/streamripper/streamripper-1.64.6.tar.gz'
  homepage 'http://streamripper.sourceforge.net/'
  md5 'a37a1a8b8f9228522196a122a1c2dd32'

  depends_on 'glib'

  def install
    fails_with_llvm "strange runtime errors with llvm"
    File.chmod 0755, "./install-sh" # without this 'make install' doesn't seem to work (permission denied)
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
