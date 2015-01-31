class Httpie < Formula
  homepage "https://github.com/jakubroztocil/httpie"
  url "https://github.com/jakubroztocil/httpie/archive/0.9.0.tar.gz"
  sha1 "4519c574979aa73e5a502f05a87c6a67e6b0db19"

  head "https://github.com/jakubroztocil/httpie.git"

  bottle do
    cellar :any
    revision 2
    sha1 "c9101c6d2acadf79f9deed22e4dbd9488f82136a" => :yosemite
    sha1 "b1dc7275b82ae7444be68df3d10b3edd9f7e0c34" => :mavericks
    sha1 "b6da6d0dd125252c75be5cbd5a6cf2a56f3e5461" => :mountain_lion
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
