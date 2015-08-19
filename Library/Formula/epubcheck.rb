class Epubcheck < Formula
  desc "Validate IDPF EPUB files, version 2.0 and later"
  homepage "https://github.com/IDPF/epubcheck"
  url "https://github.com/IDPF/epubcheck/releases/download/v3.0.1/epubcheck-3.0.1.zip"
  sha256 "530d24e0a63961df205f96e78960e08543c387eb8afc0a260714c911574fd408"

  def install
    jarname = "epubcheck-#{version}.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, "epubcheck"
  end
end
