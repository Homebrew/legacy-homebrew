class Thefuck < Formula
  homepage "https://github.com/nvbn/thefuck"
  url "https://pypi.python.org/packages/source/t/thefuck/thefuck-1.43.tar.gz"
  sha256 "24ba074a51e988ddb7dbc5dcfce70865799b33499ba46f4826329c9be961305e"

  head "https://github.com/nvbn/thefuck.git"

  bottle do
    cellar :any
    sha256 "ead4cc532a95acb5c40b0100355abb987cf92c0846ec82bddcb9247074666d1c" => :yosemite
    sha256 "83258e00f605b4b09380e18f98c1ac97c7a5d1f388cc7a8d7b56238853ea0bbd" => :mavericks
    sha256 "4b56e914e4e4e96ec9db6cc35aa1d7a19bf5b278c21f28829a0f1134782546f4" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "psutil" do
    url "https://pypi.python.org/packages/source/p/psutil/psutil-2.2.1.tar.gz"
    sha256 "a0e9b96f1946975064724e242ac159f3260db24ffa591c3da0a355361a3a337f"
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

  def install
    ENV["PYTHONPATH"] = libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    resources.each do |r|
      r.stage { system "python", *Language::Python.setup_install_args(libexec/"vendor") }
    end
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    output = shell_output(bin/"thefuck echho")
    assert output.include? "echo"
  end

  def caveats; <<-EOS.undent
    Add the following to your .bash_profile or .zshrc:
      bash: alias fuck='eval $(thefuck $(fc -ln -1)); history -r'
      zsh: alias fuck='eval $(thefuck $(fc -ln -1 | tail -n 1)); fc -R'

      Other shells: https://github.com/nvbn/thefuck/wiki/Shell-aliases
    EOS
  end
end
