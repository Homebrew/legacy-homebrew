class Cdiff < Formula
  desc "View colored diff with side by side and auto pager support"
  homepage "https://github.com/ymattw/cdiff"
  url "https://github.com/ymattw/cdiff/archive/0.9.7.tar.gz"
  sha256 "41eff442efc34e545d89b94f47da22ffc5edb4224476728746841b64b69f3512"
  head "https://github.com/ymattw/cdiff.git"

  bottle :unneeded

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
