class ClosureLinter < Formula
  desc "Check JavaScript files for style and documentation"
  homepage "https://developers.google.com/closure/utilities/"
  url "https://closure-linter.googlecode.com/files/closure_linter-2.3.13.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/c/closure-linter/closure-linter_2.3.13.orig.tar.gz"
  sha256 "7a1131389855a26be3449ba483ec3af59572859786b06b5ef8b9396440658f5a"

  head "https://github.com/google/closure-linter.git"

  bottle do
    cellar :any
    revision 1
    sha256 "8837ec50f7ee279c11ac0ccda42b6d639f2f28dea02413aa2204c85b59e6bcb7" => :yosemite
    sha256 "6a35357544d7f95a278d1b5c93ea781bfbe536a84947ff2242dc0ecad60a4102" => :mavericks
    sha256 "460363bdae3f7b93dcccf223e5fb5d530eb69ccace31e69aa68bbdb1a84c95b2" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "python-gflags" do
    url "https://pypi.python.org/packages/source/p/python-gflags/python-gflags-2.0.tar.gz"
    sha256 "0dff6360423f3ec08cbe3bfaf37b339461a54a21d13be0dd5d9c9999ce531078"
  end

  def install
    ENV["PYTHONPATH"] = libexec+"lib/python2.7/site-packages"

    resources.each do |r|
      r.stage { system "python", *Language::Python.setup_install_args(libexec) }
    end

    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*js*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"test.js").write("var test = 1;\n")
    system "#{bin}/gjslint", "test.js"
    system "#{bin}/fixjsstyle", "test.js"
  end
end
