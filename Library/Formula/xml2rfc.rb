require 'formula'

class Xml2rfc < Formula
  url 'http://xml.resource.org/authoring/xml2rfc-1.36.tgz'
  homepage 'http://xml.resource.org/'
  sha1 '36d02694d1a7392c58045162cd935adab3e7a244'

  head 'http://svn.tools.ietf.org/svn/tools/xml2rfc/trunk',
    :using => StrictSubversionDownloadStrategy

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
