class Fobis < Formula
  desc "KISS build tool for automaticaly building modern Fortran projects."
  homepage "https://github.com/szaghi/FoBiS"
  url "https://pypi.python.org/packages/source/F/FoBiS.py/FoBiS.py-1.7.4.tar.gz"
  sha256 "f63d38e532afa5b5fbe7e6d50591e161a86b78e9ecfe2273d164c330f7feb3ba"

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
