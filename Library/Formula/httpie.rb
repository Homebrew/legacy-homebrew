class Httpie < Formula
  homepage "https://github.com/jakubroztocil/httpie"
  url "https://github.com/jakubroztocil/httpie/archive/0.9.0.tar.gz"
  sha1 "4519c574979aa73e5a502f05a87c6a67e6b0db19"

  head "https://github.com/jakubroztocil/httpie.git"

  bottle do
    cellar :any
    sha1 "439df07c64a6b3e081216e9d5e780862a76e015e" => :yosemite
    sha1 "5148a218dbcf0647552164889bfb8a2937b7705d" => :mavericks
    sha1 "6ccde40c2e438e9ffff0279fa903ce13e7aa8c56" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
    sha1 "fe2c8178a039b6820a7a86b2132a2626df99c7f8"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.5.1.tar.gz"
    sha1 "f906c441be2f0e7a834cbf701a72788d3ac3d144"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[pygments requests].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    output = shell_output("#{bin}/http https://raw.githubusercontent.com/Homebrew/homebrew/master/Library/Formula/httpie.rb")
    assert output.include?("PYTHONPATH")
  end
end
