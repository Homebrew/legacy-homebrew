class Fobis < Formula
  desc "KISS build tool for automaticaly building modern Fortran projects."
  homepage "https://github.com/szaghi/FoBiS"
  url "https://pypi.python.org/packages/source/F/FoBiS.py/FoBiS.py-1.9.0.tar.gz"
  sha256 "2ea24aabee4bfeddca90782f816a60f1d5f844d9941822c1dce5f6b05cab9cda"

  bottle do
    cellar :any_skip_relocation
    sha256 "868e2fb8e1f9a892a5143f524243056eccd8a1d059258ba8d0a1385926ebabbc" => :el_capitan
    sha256 "f8727036ec9590ccb924f3731a2d78e93c6a15f62dfba96874e5db7e61363fc3" => :yosemite
    sha256 "927e81ec5da0cca19987e98fe069f2c03c7cf9eb3db97ca8cc5dda5e5bea995e" => :mavericks
  end

  option "without-pygooglechart", "Disable support for coverage charts generated with pygooglechart"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on :fortran
  depends_on "graphviz" => :recommended

  resource "pygooglechart" do
    url "https://pypi.python.org/packages/source/p/pygooglechart/pygooglechart-0.4.0.tar.gz"
    sha256 "018d4dd800eea8e0e42a4b3af2a3d5d6b2a2b39e366071b7f270e9628b5f6454"
  end

  resource "graphviz" do
    url "https://pypi.python.org/packages/source/g/graphviz/graphviz-0.4.8.zip"
    sha256 "71d56c61af9b4ff5e1e64a89b46872aa27c598bab8b0e9083f0fd3213cfc28b0"
  end

  def install
    if build.with? "pygooglechart"
      ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
      resource("pygooglechart").stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    if build.with? "graphviz"
      ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
      resource("graphviz").stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    ENV.fortran
    (testpath/"test-mod.f90").write <<-EOS.undent
      module fobis_test_m
        implicit none
        character(*), parameter :: message = "Hello FoBiS"
      end module
    EOS
    (testpath/"test-prog.f90").write <<-EOS.undent
      program fobis_test
        use iso_fortran_env, only: stdout => output_unit
        use fobis_test_m, only: message
        implicit none
        write(stdout,'(A)') message
      end program
    EOS
    system "#{bin}/FoBiS.py", "build", "-compiler", "gnu"
    assert_match /Hello FoBiS/, shell_output(testpath/"test-prog")
  end
end
