require 'formula'

class Pdfmarks < Formula
  homepage 'https://bitbucket.org/alexreg/pdfmarks'
  url 'https://bitbucket.org/alexreg/pdfmarks/get/0.1.tar.gz'
  sha1 '8897430451ae0d46e5a507710f9c3f42af5c8d90'

  depends_on 'ghostscript'

  def install
    inreplace 'pdfmarks' do |s|
      s.gsub! "source \"common\"", "source \"#{libexec}/common\""
      s.gsub! "\"pdfmarks.ps\"", "\"#{share}/pdfmarks.ps\""
    end

    share.install('pdfmarks.ps')
    libexec.install('common')
    bin.install('pdfmarks')
  end

  test do
    system "#{bin}/pdfmarks", "-h"
  end
end
