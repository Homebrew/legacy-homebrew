class Ranger < Formula
  desc "File browser"
  homepage "http://ranger.nongnu.org/"
  url "http://ranger.nongnu.org/ranger-1.7.2.tar.gz"
  sha256 "94f6e342daee4445f15db5a7440a11138487c49cc25da0c473bbf1b8978f5b79"

  head "git://git.savannah.nongnu.org/ranger.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "82eb23ac75480e1f83087dd04e6d537c5b141e35de922729f8b83e0cdcdd45aa" => :el_capitan
    sha256 "8592a7b7af5b59932b01c685afaa53173a11efcead0526e30464467f944d649c" => :yosemite
    sha256 "cf9b172937e85e6a4bcfca8508378fcaf9aa81fdf18df0a3cab531cc3f27cc2a" => :mavericks
  end

  # requires 2.6 or newer; Leopard comes with 2.5
  depends_on :python if MacOS.version <= :leopard

  def install
    inreplace %w[ranger.py ranger/ext/rifle.py] do |s|
      s.gsub! "#!/usr/bin/python", "#!#{PythonRequirement.new.which_python}"
    end if MacOS.version <= :leopard

    man1.install "doc/ranger.1"
    libexec.install "ranger.py", "ranger"
    bin.install_symlink libexec+"ranger.py" => "ranger"
    doc.install "examples"
  end

  test do
    assert_match version.to_s, shell_output("script -q /dev/null #{bin}/ranger --version")
  end
end
