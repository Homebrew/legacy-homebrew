class Epubcheck < Formula
  desc "Validate IDPF EPUB files, version 2.0 and later"
  homepage "https://github.com/IDPF/epubcheck"
  url "https://github.com/IDPF/epubcheck/releases/download/v4.0.1/epubcheck-4.0.1.zip"
  sha256 "ef1973ed8ada1e7f875cd1b9cc61c4ddf72e131a1865d00f48e19e0caab288ba"

  bottle :unneeded

  def install
    jarname = "epubcheck.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, "epubcheck"
  end
end
