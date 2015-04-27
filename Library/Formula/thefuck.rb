class Thefuck < Formula
  homepage "https://github.com/nvbn/thefuck"
  url "https://pypi.python.org/packages/source/t/thefuck/thefuck-1.29.tar.gz"
  sha256 "3e51de66ea29a1bbd9f1aadbd3a2398601e7a5e7ab69fef0f75677ca95f00cb1"

  bottle do
    cellar :any
    sha256 "257c5674dd683812bda279eb9709809440d7cba032862d234523a0e2dfd38d1d" => :yosemite
    sha256 "b2cfa406696a624e311bed92ef08c314f0fe6c893308d8e67fecc08102da9b32" => :mavericks
    sha256 "68a2b3f99d193ab817f31e8c7941d0f4574eccb36f9f29884e9d03e608999afe" => :mountain_lion
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

    %w[psutil pathlib colorama six].each do |r|
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
