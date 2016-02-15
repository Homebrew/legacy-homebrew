class Cdiff < Formula
  desc "View colored diff with side by side and auto pager support"
  homepage "https://github.com/ymattw/cdiff"
  url "https://github.com/ymattw/cdiff/archive/0.9.8.tar.gz"
  sha256 "676f025b385c40bdf784aabf8381b2006f5e3befc2768c4d454a276f759221f1"
  head "https://github.com/ymattw/cdiff.git"

  bottle :unneeded

  conflicts_with "colordiff", :because => "both install `cdiff` binaries"
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    diff_fixture = test_fixtures("test.diff").read
    assert_equal diff_fixture,
      pipe_output("#{bin}/cdiff -cnever", diff_fixture)
  end
end
