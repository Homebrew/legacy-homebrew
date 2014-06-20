require 'formula'

class Binwalk < Formula
  homepage 'http://binwalk.org/'
  url 'https://github.com/devttys0/binwalk/archive/v1.3.0.tar.gz'
  sha1 '6cab158b69e508081302305b354da12f45658272'

  head 'https://github.com/devttys0/binwalk.git'

  option 'with-matplotlib', 'Check for presence of matplotlib, which is required for entropy graphing support'

  depends_on 'swig' => :build
  depends_on :fortran
  depends_on 'libmagic' => 'with-python'
  depends_on 'matplotlib' => :python if build.with? 'matplotlib'
  depends_on 'pyside'
  depends_on :python if MacOS.version <= :snow_leopard

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

    cd "src" do
      binwalk_args = [ "install", "--prefix=#{prefix}" ]
      system "python", "setup.py", *binwalk_args
      bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
    end
  end

  test do
    touch "binwalk.test"
    system "#{bin}/binwalk", "binwalk.test"
  end
end
