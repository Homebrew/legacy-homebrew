class Ranger < Formula
  desc "File browser"
  homepage "http://ranger.nongnu.org/"
  url "http://ranger.nongnu.org/ranger-1.7.1.tar.gz"
  sha256 "f8b06135165142508ae7ec22ab2c95f6e51b4018c645d11226086d4c45b7df86"

  head "git://git.savannah.nongnu.org/ranger.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b71c72d76937f8ae47761ba3c642eaef9e121a1b9fc5173d56a42b321f80e9ec" => :el_capitan
    sha256 "5f0901ba96568d3f8ba713bbb39939538cbcdd1dffa06beee98c5cce13405d20" => :yosemite
    sha256 "97bf46731d0b5cc20adbd3bd6052ca36508cb3b6deccb80c42cd5cc1ab5d83bc" => :mavericks
    sha256 "f64e5e2629bcd9bffc74b3453539ce956a293cad9d2925aef5e5f1cd532c5c09" => :mountain_lion
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
