require 'formula'

class Pdfmarks < Formula
  homepage 'https://bitbucket.org/alexreg/pdfmarks'
  url 'https://bitbucket.org/alexreg/pdfmarks/get/v0.2.tar.gz'
  sha1 '75943601cfb3b8aed110357a152838b86507403b'

  depends_on 'ghostscript'

  def install
    inreplace 'pdfmarks' do |s|
      s.gsub! "source \"common\"", "source \"#{libexec}/common\""
      s.gsub! "\"pdfmarks.ps\"", "\"#{share}/pdfmarks.ps\""
    end

    share.install 'pdfmarks.ps'
    libexec.install 'common'
    bin.install 'pdfmarks'
  end

  test do
    system "#{bin}/pdfmarks", "-h"
  end
end
