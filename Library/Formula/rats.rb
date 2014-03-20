require 'formula'

class Rats < Formula
  homepage 'https://security.web.cern.ch/security/recommendations/en/codetools/rats.shtml'
  url 'https://rough-auditing-tool-for-security.googlecode.com/files/rats-2.4.tgz'
  sha1 '1063210dbad5bd9f287b7b80bd7e412a63ae1792'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make install"
  end

  test do
    system "#{bin}/rats"
  end
end
