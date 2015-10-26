class Epubcheck < Formula
  desc "Validate IDPF EPUB files, version 2.0 and later"
  homepage "https://github.com/IDPF/epubcheck"
  url "https://github.com/IDPF/epubcheck/releases/download/v4.0.0/epubcheck-4.0.0.zip"
  sha256 "6a2b73ddbe8aa5a83ee551b73297429daa73156192661ac28c1fbb39fa7edbdc"

  bottle :unneeded

  def install
    jarname = "epubcheck.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, "epubcheck"
  end
end
