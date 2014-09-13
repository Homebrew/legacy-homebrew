require 'formula'

class NoExpatFramework < Requirement
  def expat_framework
    '/Library/Frameworks/expat.framework'
  end

  satisfy :build_env => false do
    not File.exist? expat_framework
  end

  def message; <<-EOS.undent
    Detected #{expat_framework}

    This will be picked up by CMake's build system and likely cause the
    build to fail, trying to link to a 32-bit version of expat.

    You may need to move this file out of the way to compile CMake.
    EOS
  end
end

class Cmake < Formula
  homepage 'http://www.cmake.org/'
  url 'http://www.cmake.org/files/v3.0/cmake-3.0.2.tar.gz'
  sha1 '379472e3578902a1d6f8b68a9987773151d6f21a'

  head 'http://cmake.org/cmake.git'

  bottle do
    cellar :any
    sha1 "7e4815ddbd283d7754dae04d585995a0ba68e38f" => :mavericks
    sha1 "5a9299d20fbbdbfe594baeec10fe448d40c2d05f" => :mountain_lion
    sha1 "dba7684d1d65423df75fd28f459525eb08590232" => :lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource 'jinja' do
    url 'https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz'
    sha1 '25ab3881f0c1adfcf79053b58de829c5ae65d3ac'
  end

  resource 'docutils' do
    url 'https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz'
    sha1 '002450621b33c5690060345b0aac25bc2426d675'
  end

  resource 'pygments' do
    url 'https://pypi.python.org/packages/source/P/Pygments/Pygments-1.6.tar.gz'
    sha1 '53d831b83b1e4d4f16fec604057e70519f9f02fb'
  end

  resource 'markupsafe' do
    url 'https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz'
    sha1 'cd5c22acf6dd69046d6cb6a3920d84ea66bdf62a'
  end

  resource 'sphinx' do
    url 'https://pypi.python.org/packages/source/S/Sphinx/Sphinx-1.2.3.tar.gz'
    sha1 '3a11f130c63b057532ca37fe49c8967d0cbae1d5'
  end

  depends_on NoExpatFramework

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"

    resources.each do |r|
      r.stage { system "python", "setup.py", "install", "--prefix=#{libexec}" }
    end

    rm "#{libexec}/lib/python2.7/site-packages/site.py"
    rm "#{libexec}/lib/python2.7/site-packages/easy-install.pth"
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    args = %W[
      --prefix=#{prefix}
      --system-libs
      --no-system-libarchive
      --sphinx-man
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
    ]

    system "./bootstrap", *args
    system "make"
    system "make install"
  end

  test do
    (testpath/'CMakeLists.txt').write('find_package(Ruby)')
    system "#{bin}/cmake", '.'
  end
end
