class ClosureLinter < Formula
  desc "Check JavaScript files for style and documentation"
  homepage "https://developers.google.com/closure/utilities/"
  url "https://github.com/google/closure-linter/archive/v2.3.19.tar.gz"
  sha256 "cd472f560be5af80afccbe94c9d9b534f7c30085510961ad408f8a314ea5c4c2"

  head "https://github.com/google/closure-linter.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "44607d2104144e462b1a87313345f9205f66d9d2ee03f5ad306e5f532a95d0c0" => :el_capitan
    sha256 "1fba2b6ce208cc1944ecb7aaf1e4998f439f248234f51854523b04be96babb8d" => :yosemite
    sha256 "a5f04eab15b5496bc5309b420552a2f13392606bab465beaf0cce27119557b61" => :mavericks
    sha256 "beaed6105607c8d7096707904aa6b1d51dfe3f119d709ddb6d0dba93691323bb" => :mountain_lion
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
    assert_equal "1 files checked, no errors found.", shell_output("#{bin}/gjslint test.js").chomp
    system "#{bin}/fixjsstyle", "test.js"
  end
end
