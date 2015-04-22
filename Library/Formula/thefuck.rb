class Thefuck < Formula
  homepage "https://github.com/nvbn/thefuck"
  url "https://pypi.python.org/packages/source/t/thefuck/thefuck-1.26.tar.gz"
  sha256 "b81e0d4ac5eb3e3aec1014d948d26419a60a39cc1e20f20d82f7be652ed3b8c8"

  bottle do
    cellar :any
    sha256 "826523b7e2239127c65ee38ec6cd05ff630ddb76ae2b34cd2632c23e8651bccb" => :yosemite
    sha256 "0c45edcf78a080a5fed9851205ea1f295d892f97ca83ecc9039e4609496e5478" => :mavericks
    sha256 "f51e804a09b7d6699bb1ccca568245f1f71b06c58a656c01b5247df1809e2634" => :mountain_lion
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

  def install
    ENV["PYTHONPATH"] = libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    %w[psutil pathlib].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
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
      alias fuck='$(thefuck $(fc -ln -1))'
    Or in config.fish:
      function fuck
        eval (thefuck $history[1])
      end
    EOS
  end
end
