class Thefuck < Formula
  desc "Programatically correct mistyped console commands"
  homepage "https://github.com/nvbn/thefuck"
  url "https://pypi.python.org/packages/source/t/thefuck/thefuck-1.46.tar.gz"
  sha256 "d34dbadea0b399229a4f2b19c848d3281c7bd9a1dacd26ee44484a26bba4056d"

  head "https://github.com/nvbn/thefuck.git"

  bottle do
    cellar :any
    sha256 "9bc1f8588e33a8f15df5e128cacc42edae6fdcc97dd9976c996d61e1e0772b14" => :yosemite
    sha256 "156441667763715e4b01c84f13338464c25af98bc8ccd89ce9e3f98b4d4b46a8" => :mavericks
    sha256 "a1e7276ed57bf76d8c157e6b544f3315fa059137c32620c69144578b68a590a5" => :mountain_lion
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
