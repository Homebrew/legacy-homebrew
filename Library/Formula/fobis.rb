class Fobis < Formula
  desc "KISS build tool for automaticaly building modern Fortran projects."
  homepage "https://github.com/szaghi/FoBiS"
  url "https://pypi.python.org/packages/source/F/FoBiS.py/FoBiS.py-1.8.4.tar.gz"
  sha256 "2f55ec1ef0b70c8870d497697f8c0cab3012e391db1b80481b32869358fb10f7"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa9196d1ef006a21b658005dbae886b7a74b7163c647a677eed52c56ee3b6d8c" => :el_capitan
    sha256 "f43599ff4c43494bb4c9ada4b06c62a40df5692761eb3a26aab3c689361941ec" => :yosemite
    sha256 "cb16c0c004c5471ba3f7a6454b74b0b8c91172e2db067fcb8874d53eb77bf81e" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on :fortran

  def install
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
