class Naturaldocs < Formula
  desc "Extensible, multi-language documentation generator"
  homepage "http://www.naturaldocs.org/"
  url "https://downloads.sourceforge.net/project/naturaldocs/Stable%20Releases/1.52/NaturalDocs-1.52.zip"
  sha256 "3f13c99e15778afe6c5555084a083f856e93567b31b08acd1fd81afb10082681"

  bottle :unneeded

  def install
    # Remove Windows files
    rm_rf Dir["*.bat"]

    libexec.install Dir["*"]
    chmod 0755, libexec+"NaturalDocs"
    bin.install_symlink libexec+"NaturalDocs"
  end
end
