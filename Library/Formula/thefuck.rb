class Thefuck < Formula
  desc "Programatically correct mistyped console commands"
  homepage "https://github.com/nvbn/thefuck"
  url "https://pypi.python.org/packages/source/t/thefuck/thefuck-2.8.tar.gz"
  sha256 "40ac6c27974fc749557fe37f00e29100c26f25f038f3e63034f721442ac0b489"

  head "https://github.com/nvbn/thefuck.git"

  bottle do
    cellar :any
    sha256 "fafef0f2d06b9ccab5d035f041d656167c37372e33d0039b0d260a27b7067938" => :yosemite
    sha256 "90a62137449bc70c077d98e5fa1ee4a233a84550de8a1ceaa78eb215fdc9d66a" => :mavericks
    sha256 "48eb9527a4c6405d90f9d8c328635da50d5445ba5e78c1c1b51e203d0bfe8d0c" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "psutil" do
    url "https://pypi.python.org/packages/source/p/psutil/psutil-3.1.1.tar.gz"
    sha256 "d3290bd4a027fa0b3a2e2ee87728056fe49d4112640e2b8c2ea4dd94ba0cf057"
  end

  resource "pathlib" do
    url "https://pypi.python.org/packages/source/p/pathlib/pathlib-1.0.1.tar.gz"
    sha256 "6940718dfc3eff4258203ad5021090933e5c04707d5ca8cc9e73c94a7894ea9f"
  end

  resource "colorama" do
    url "https://pypi.python.org/packages/source/c/colorama/colorama-0.3.3.tar.gz"
    sha256 "eb21f2ba718fbf357afdfdf6f641ab393901c7ca8d9f37edd0bee4806ffa269c"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-18.2.tar.gz"
    sha256 "0994a58df27ea5dc523782a601357a2198b7493dcc99a30d51827a23585b5b1d"
  end

  def install
    xy = Language::Python.major_minor_version "python"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    %w[setuptools pathlib psutil colorama six].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<-EOS.undent
    Add the following to your .bash_profile, .bashrc or .zshrc:

      eval "$(thefuck --alias)"

    For other shells, check https://github.com/nvbn/thefuck/wiki/Shell-aliases
    EOS
  end

  test do
    assert_equal "The Fuck #{version}", shell_output("#{bin}/thefuck --version 2>&1").chomp
    assert_match /.+TF_ALIAS.+thefuck.+/, shell_output("#{bin}/thefuck --alias").chomp
    IO.popen("#{bin}/thefuck git branchh 2>&1", "r+") do |pipe|
      pipe.puts "\n"
      pipe.close_write
      assert_match /git branch.+/, pipe.gets.chomp
      pipe.close
    end
  end
end
