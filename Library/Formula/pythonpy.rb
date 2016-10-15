class Pythonpy < Formula
  homepage "https://github.com/Russell91/pythonpy"
  url "https://pypi.python.org/packages/source/p/pythonpy/pythonpy-0.3.6.tar.gz"
  sha1 "180e4cd00f89cc00d8a657fc7a2d8af4da8b487c"
  head "https://github.com/Russell91/pythonpy.git"

  depends_on :python => :recommended
  depends_on :python3 => :optional

  def install
    if build.without?("python") && build.without?("python3")
      odie "You need to build against one python version."
    end

    Language::Python.each_python(build) do |python, version|
      ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{version}/site-packages"
      system python, *Language::Python.setup_install_args(libexec)

      # Cannot use bin.env_script_all_files since it would overwrite python2
      # executables, if both versions are going to be installed
      version = version.to_s
      execs_to_wrap = [
        "py#{version}", "py#{version[0..0]}",
        "pycompleter#{version}", "pycompleter#{version[0..0]}"
      ]
      execs_to_wrap.each do |e|
        (bin/e).write_env_script(libexec/"bin"/e, :PYTHONPATH => ENV["PYTHONPATH"])
      end
    end

    # Prefer the python3 version of the "py" executable, if both are available
    if build.with? "python3"
      bin.install_symlink bin/"py3" => "py"
      bin.install_symlink bin/"pycompleter3" => "pycompleter"
    else
      bin.install_symlink bin/"py2" => "py"
      bin.install_symlink bin/"pycompleter2" => "pycompleter"
    end

    bash_completion.install libexec/"bash_completion.d/pycompletion.sh"
  end

  test do
    assert_equal "13.5", `#{bin}/py 3*4.5`.strip

    if build.with? "python"
      assert_equal "2.7", `#{bin}/py2 sys.version`[0..2]
      assert_equal "2.7", `#{bin}/py2.7 sys.version`[0..2]
    end

    if build.with? "python3"
      assert_equal "3", `#{bin}/py3 sys.version`[0..0]
    end
  end
end
