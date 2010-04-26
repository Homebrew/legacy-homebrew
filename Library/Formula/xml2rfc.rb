require 'formula'

class Xml2rfc <Formula
  url 'http://xml.resource.org/authoring/xml2rfc-1.35.tgz'
  md5 '7ffb973fee55318b1bd0fd77a903d2e6'
  head 'https://svn.tools.ietf.org/svn/tools/xml2rfc/trunk'
  homepage 'http://xml.resource.org/'

  # http://github.com/mxcl/homebrew/issues/#issue/87
  depends_on :subversion if MACOS_VERSION < 10.6 and ARGV.include? '--HEAD'

  def download_strategy
    if ARGV.include? '--HEAD'
      SubversionDownloadStrategy
    else
      CurlDownloadStrategy
    end
  end

  def install
    %w[xml2rfc xml2sgml].each do |f|
      bin.install f+'.tcl' => f
    end

    %w[xml2txt xml2html xml2nroff].each do |f|
      ln_s "#{bin}/xml2rfc", "#{bin}/#{f}"
    end

    doc.install Dir["*"]
  end
end
