require 'formula'

class Binwalk < Formula
  homepage 'http://binwalk.org/'
  stable do
    url "https://github.com/devttys0/binwalk/archive/v2.0.1.tar.gz"
    sha1 "b0ec783cbf72db358c5118a3052fc1ccf446d8f3"
  end

  bottle do
    sha1 "d32f66ae40876307fe6fb1784f4381fc2c6f80cf" => :mavericks
    sha1 "d8b2dce1f5e57068458a217b9ae5d349cfb6e515" => :mountain_lion
    sha1 "177c7820cc1289b0055d22174f094c06d1152b4c" => :lion
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
    url "http://downloads.sourceforge.net/project/numpy/NumPy/1.8.1/numpy-1.8.1.tar.gz"
    sha1 "8fe1d5f36bab3f1669520b4c7d8ab59a21a984da"
  end

  resource 'scipy' do
    url "http://downloads.sourceforge.net/project/scipy/scipy/0.14.0/scipy-0.14.0.tar.gz"
    sha1 "faf16ddf307eb45ead62a92ffadc5288a710feb8"
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

    system "autoreconf -f" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-bundles"
    system "make install"
  end

  test do
    touch "binwalk.test"
    system "#{bin}/binwalk", "binwalk.test"
  end
end
