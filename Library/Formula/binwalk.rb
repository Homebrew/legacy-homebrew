require 'formula'

class Binwalk < Formula
  homepage 'http://binwalk.org/'
  stable do
    url 'https://github.com/devttys0/binwalk/archive/v1.3.0.tar.gz'
    sha1 '6cab158b69e508081302305b354da12f45658272'

    # Fix install locations; submitted upstream as various PRs
    patch do
        url "https://gist.github.com/balr0g/e3a5c97151b6c03619b3/raw/2a67afc3613b435ef785b18ff1ed44b676576dbf/binwalk-1.3.0-setup.patch"
        sha1 "893e6b7d9df93ace304e07ac7897498108870fc6"
    end
  end

  head do
    url 'https://github.com/devttys0/binwalk.git'
    depends_on "automake" => :build
    depends_on "autoconf" => :build

    patch do
      url "https://gist.github.com/balr0g/a917b31318016c63a72d/raw/d434c3ceaa57438d39344e760990e9268893ce5f/binwalk-head-201140712.patch"
      sha1 "2e000654968d2c8ad17b7fc46924300cf01bbfed"
    end
  end

  option 'with-matplotlib', 'Check for presence of matplotlib, which is required for entropy graphing support'

  depends_on 'swig' => :build
  depends_on :fortran
  depends_on 'libmagic' => 'with-python'
  depends_on 'matplotlib' => :python if build.with? 'matplotlib'
  depends_on 'pyside'
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on 'p7zip'
  depends_on 'ssdeep'
  depends_on 'xz'

  resource 'pyqtgraph' do
    url 'http://www.pyqtgraph.org/downloads/pyqtgraph-0.9.8.tar.gz'
    sha1 '4ea6891f562c09ff13555ccb33fe05c315a70cf1'
  end

  resource 'numpy' do
    url 'http://downloads.sourceforge.net/project/numpy/NumPy/1.8.0/numpy-1.8.0.tar.gz'
    sha1 'a2c02c5fb2ab8cf630982cddc6821e74f5769974'
  end

  resource 'scipy' do
    url 'http://downloads.sourceforge.net/project/scipy/scipy/0.13.3/scipy-0.13.3.tar.gz'
    sha1 '2c7d53fc1d7bfe0a3ab5818ef6d84cb5d8cfcca4'
  end

  def install
    ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
    numpy_args = [ "build", "--fcompiler=gnu95",
                   "install", "--prefix=#{libexec}" ]
    resource('numpy').stage { system "python", "setup.py", *numpy_args }
    scipy_args = [ "build", "--fcompiler=gnu95",
                   "install", "--prefix=#{libexec}" ]
    resource('scipy').stage { system "python", "setup.py", *scipy_args }
    pyqtgraph_args = [ "setup.py", "install", "--prefix=#{libexec}" ]
    resource('pyqtgraph').stage { system "python", *pyqtgraph_args }

    if build.head?
      system "autoreconf -f"
      system "./configure", "--prefix=#{prefix}"
      system "make install"
    else
      cd "src" do
        binwalk_args = [ "install", "--prefix=#{prefix}", "--yes" ]
        system "python", "setup.py", *binwalk_args
        bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
      end
    end
  end

  test do
    touch "binwalk.test"
    system "#{bin}/binwalk", "binwalk.test"
  end
end
