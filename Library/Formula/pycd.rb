class Pycd < Formula
  desc "change directory for python modules"
  homepage "https://github.com/wkentaro/pycd"
  url "https://github.com/wkentaro/pycd/archive/0.3.0.tar.gz"
  sha256 "45dede5f75de3feeb4e9474d2ca0ae4462d54973305cb9788aeab3c64f6e78ed"

  head 'https://github.com/wkentaro/pycd.git'

  depends_on :python if MacOS.version <= :snow_leopard

  # MacOS versions prior to Yosemite need the latest setuptools in order to compile dependencies
  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-17.0.tar.gz"
    sha256 "561b33819ef3da2bff89cc8b05fd9b5ea3caeb31ad588b53fdf06f886ac3d200"
  end

  resource "args" do
    url "https://github.com/kennethreitz/args/archive/v0.1.0.tar.gz"
    sha256 "ead9ed80cbb64179a768d2aba8edba9f83dc2e33dc91ac07a7479f3d74119568"
  end

  resource "clint" do
    url "https://github.com/kennethreitz/clint/archive/v0.4.1.tar.gz"
    sha256 "6709b638fd13fc2395284d0d42fe857ce97fdb6f03929ceb7ece28393933b4ea"
  end


  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # Install bash completion
    bash_completion.install "pycd-completion.bash" => "pycd-completion.bash"

    # Install zsh completion
    zsh_completion.install "_pycd" => "_pycd"
    zsh_completion.install "_pypkg" => "_pypkg"

    # pycd function
    share.install "pycd.sh"

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<-EOS.undent
    To finish the installation, source pycd.sh in your shell:
      source #{opt_share}/pycd.sh
    EOS
  end

  test do
    assert_equal shell_output("pypkg find os").strip,
                 shell_output("source #{opt_share}/pycd.sh && pycd os && pwd").strip
  end
end
