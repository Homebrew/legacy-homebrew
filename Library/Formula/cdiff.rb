class Cdiff < Formula
  desc "View colored diff with side by side and auto pager support"
  homepage "https://github.com/ymattw/cdiff"
  url "https://github.com/ymattw/cdiff/archive/0.9.7.tar.gz"
  sha256 "41eff442efc34e545d89b94f47da22ffc5edb4224476728746841b64b69f3512"
  head "https://github.com/ymattw/cdiff.git"

  bottle :unneeded

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    diff_fixture = File.read test_fixtures "test.diff"
    diff = pipe_output "#{bin}/cdiff -cnever", diff_fixture
    assert_equal diff, diff_fixture
  end
end
