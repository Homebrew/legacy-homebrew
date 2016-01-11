class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "http://www.openbabel.org"

  stable do
    url "https://downloads.sourceforge.net/project/openbabel/openbabel/2.3.2/openbabel-2.3.2.tar.gz"
    sha256 "4eaca26679aa6cc85ebf96af19191472ac63ca442c36b0427b369c3a25705188"

    # Patch to support libc++ in OS X 10.9+, backport of upstream commit c3abbddae78e654df9322ad1020ff79dd6332946
    patch do
      url "https://gist.githubusercontent.com/erlendurj/40689d57bea3b0b0c767/raw/f8c87557bcdbd79fb796e06088cdd77123c9260a/ob-mavericks.patch"
      sha256 "b6b1a46f5c0e98763e1fec85523646bb43aae800449e076d63adff93e7302212"
    end

    # Patch to fix Molecule.draw() in pybel in accordance with upstream commit df59c4a630cf753723d1318c40479d48b7507e1c
    patch do
      url "https://gist.githubusercontent.com/fredrikw/5858168/raw/e4b5899e781d5707f5c386e436b5fc7810f2010d/ob-2-3-2-patch.diff"
      sha256 "52141601c7c87eaf3dec877b9120ac0eac2d1a75e3f0c1d82b6521f32410a892"
    end
  end
  bottle do
    sha256 "e632200d401723ed2f24181a785eb10234d2698a5d360f22356a13063bd46f0e" => :yosemite
    sha256 "4e18fbaba55efdc7a2f07743afeda5cb32d13ac987c1929968bef8ef16d3859b" => :mavericks
    sha256 "0350407844a4bbc86dbf0c6dd562ca6bac7b71b92251cfdf222a9f1d2a092306" => :mountain_lion
  end

  head do
    url "https://github.com/openbabel/openbabel.git"
  end

  option "with-cairo",  "Support PNG depiction"
  option "with-java",   "Compile Java language bindings"
  option "with-python", "Compile Python language bindings"
  option "with-wxmac",  "Build with GUI"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on :python => :optional
  depends_on "wxmac" => :optional
  depends_on "cairo" => :optional
  depends_on "eigen"
  depends_on "swig" if build.with?("python") || build.with?("java")

  def install
    args = std_cmake_args
    args << "-DRUN_SWIG=ON" if build.with?("python") || build.with?("java")
    args << "-DJAVA_BINDINGS=ON" if build.with? "java"
    args << "-DBUILD_GUI=ON" if build.with? "wxmac"

    # Look for Cairo in HOMEBREW_PREFIX (automatic detection with cmake is fixed in HEAD)
    if build.with?("cairo") && !build.head?
      args << "-DCAIRO_INCLUDE_DIRS='#{HOMEBREW_PREFIX}/include/cairo'"
      args << "-DCAIRO_LIBRARIES='#{HOMEBREW_PREFIX}/lib/libcairo.dylib'"
    end

    # Point cmake towards correct python
    if build.with? "python"
      pypref = `python -c 'import sys;print(sys.prefix)'`.strip
      pyinc = `python -c 'from distutils import sysconfig;print(sysconfig.get_python_inc(True))'`.strip
      args << "-DPYTHON_BINDINGS=ON"
      args << "-DPYTHON_INCLUDE_DIR='#{pyinc}'"
      args << "-DPYTHON_LIBRARY='#{pypref}/lib/libpython2.7.dylib'"
    end

    args << ".."

    mkdir "build" do
      system "cmake", *args
      system "make"
      system "make", "install"
    end

    # Manually install the python files (fixed in HEAD)
    if build.with?("python") && !build.head?
      (lib+"python2.7/site-packages").install lib/"openbabel.py", lib/"pybel.py", lib/"_openbabel.so"
    end
  end

  def caveats
    <<-EOS.undent
      Java libraries are installed to #{HOMEBREW_PREFIX}/lib so this path should be
      included in the CLASSPATH environment variable.
    EOS
  end

  test do
    system "obabel", "-:'C1=CC=CC=C1Br'", "-omol"
  end
end
