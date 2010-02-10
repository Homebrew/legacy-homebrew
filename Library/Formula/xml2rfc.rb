require 'formula'

class Xml2rfc <Formula
  head 'https://svn.tools.ietf.org/svn/tools/xml2rfc/trunk'
  homepage 'http://xml.resource.org/'

  # http://github.com/mxcl/homebrew/issues/#issue/87
  depends_on :subversion if MACOS_VERSION < 10.6

  def install
    %w[xml2rfc xml2sgml].each do |f|
      FileUtils.mv f+'.tcl', f
      bin.install f
    end
    %w[xml2txt xml2html xml2nroff].each do |f|
      FileUtils.ln "#{prefix}/bin/xml2rfc", "#{prefix}/bin/"+f
    end    
    Dir["*"].each {|f| doc.install f}    
  end
end
