require 'formula'

class Epubcheck < Formula
  desc "Validate IDPF EPUB files, version 2.0 and later"
  homepage 'https://github.com/IDPF/epubcheck'
  url 'https://github.com/IDPF/epubcheck/releases/download/v3.0.1/epubcheck-3.0.1.zip'
  sha1 '80a61fb2817ec547d292362793da5b91dbef92e3'

  def install
    jarname = "epubcheck-#{version}.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, 'epubcheck'
  end
end
