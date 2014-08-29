require 'formula'

class OpenBabel < Formula
  homepage 'http://www.openbabel.org'
  url 'https://downloads.sourceforge.net/project/openbabel/openbabel/2.3.2/openbabel-2.3.2.tar.gz'
  sha1 'b8831a308617d1c78a790479523e43524f07d50d'

  option 'with-cairo',  'Support PNG depiction'
  option 'with-java',   'Compile Java language bindings'

  depends_on 'pkg-config' => :build
  depends_on 'cmake' => :build
  depends_on :python => :optional
  depends_on 'wxmac' => :optional
  depends_on 'cairo' => :optional
  depends_on 'eigen' if build.with?('python') || build.with?('java')

  # Patch to fix Molecule.draw() in pybel in accordance with upstream commit df59c4a630cf753723d1318c40479d48b7507e1c
  patch do
    url "https://gist.githubusercontent.com/fredrikw/5858168/raw/e4b5899e781d5707f5c386e436b5fc7810f2010d/ob-2-3-2-patch.diff"
    sha1 "e304c308b39a465b632b397aa669c26f4b375da1"
  end

  # Patch to support Mavericks's libc++, a backport of upstream commit c3abbddae78e654df9322ad1020ff79dd6332946
  patch do
    url "https://gist.githubusercontent.com/erlendurj/40689d57bea3b0b0c767/raw/f8c87557bcdbd79fb796e06088cdd77123c9260a/ob-mavericks.patch"
    sha1 "3ea95b20fdbe50f656f3073ef8916974495b569a"
  end

  def install
    args = %W[ -DCMAKE_INSTALL_PREFIX=#{prefix} ]
    args << "-DJAVA_BINDINGS=ON" if build.with? 'java'
    args << "-DBUILD_GUI=ON" if build.with? 'wxmac'
    # Looking for Cairo in HOMEBREW_PREFIX
    # setting the arguments separately, joining them in one string fails with the 'system "cmake", *args' command
    args << "-DCAIRO_INCLUDE_DIRS='#{HOMEBREW_PREFIX}/include/cairo'" if build.with? 'cairo'
    args << "-DCAIRO_LIBRARIES='#{HOMEBREW_PREFIX}/lib/libcairo.dylib'" if build.with? 'cairo'

    args << "-DPYTHON_BINDINGS=ON" if build.with? 'python'

    args << '..'

    mkdir 'build' do
      system "cmake", *args
      system "make"
      system "make install"
    end

    if build.with? 'python'
      (lib+'python2.7/site-packages').install lib/'openbabel.py', lib/'pybel.py', lib/'_openbabel.so'
    end
  end

  def caveats
    <<-EOS.undent
      Java libraries are installed to #{HOMEBREW_PREFIX}/lib so this path should be
      included in the CLASSPATH environment variable.
    EOS
  end

end
