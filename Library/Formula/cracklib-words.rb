require 'formula'

class CracklibWords <Formula
  url 'http://downloads.sourceforge.net/project/cracklib/cracklib-words/2008-05-07/cracklib-words-20080507.gz',
    :using => NoUnzipCurlDownloadStrategy
  homepage 'http://cracklib.sourceforge.net'
  md5 '7fa6ba0cd50e7f9ccaf4707c810b14f1'

  depends_on 'cracklib'

  def install
    system "gzip", "-d", "cracklib-words-20080507.gz"
    share.install "cracklib-words-20080507" => "cracklib-words"
    system "/bin/sh", "-c", "cracklib-packer < #{share}/cracklib-words"
  end
end
