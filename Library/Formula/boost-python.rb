class BoostPython < Formula
  desc "C++ library for C++/Python interoperability"
  homepage "http://www.boost.org"
  url "https://downloads.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.bz2"
  sha256 "727a932322d94287b62abb1bd2d41723eec4356a7728909e38adb65ca25241ca"
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any
    revision 1
    sha256 "4b16817f7f19f1b4ee2ffc4e0fc4593a5d404ddad2703f3be688ab6498f24f3e" => :el_capitan
    sha256 "df627b338b9b42510eb5670d6e65856164d11714cfd436a19fd36c7ba0775259" => :yosemite
    sha256 "2f5a292bddc892d6660179dab8b67261b3db93311f2a4b230256da5010f5c5d3" => :mavericks
  end

  option :universal
  option :cxx11

  option "without-python", "Build without python 2 support"
  depends_on :python3 => :optional

  if build.cxx11?
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  fails_with :llvm do
    build 2335
    cause "Dropped arguments to functions when linking with boost"
  end

  def install
    ENV.universal_binary if build.universal?

    if stable?
      # fix make_setter regression
      # https://github.com/boostorg/python/pull/40
      inreplace "boost/python/data_members.hpp",
                "# if BOOST_WORKAROUND(__EDG_VERSION__, <= 238)",
                "# if !BOOST_WORKAROUND(__EDG_VERSION__, <= 238)"
    end

    # "layout" should be synchronized with boost
    args = ["--prefix=#{prefix}",
            "--libdir=#{lib}",
            "-d2",
            "-j#{ENV.make_jobs}",
            "--layout=tagged",
            "--user-config=user-config.jam",
            "threading=multi,single",
            "link=shared,static"]

    args << "address-model=32_64" << "architecture=x86" << "pch=off" if build.universal?

    # Build in C++11 mode if boost was built in C++11 mode.
    # Trunk starts using "clang++ -x c" to select C compiler which breaks C++11
    # handling using ENV.cxx11. Using "cxxflags" and "linkflags" still works.
    if build.cxx11?
      args << "cxxflags=-std=c++11"
      if ENV.compiler == :clang
        args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++"
      end
    elsif Tab.for_name("boost").cxx11?
      odie "boost was built in C++11 mode so boost-python must be built with --c++11."
    end

    # disable python detection in bootstrap.sh; it guesses the wrong include directory
    # for Python 3 headers, so we configure python manually in user-config.jam below.
    inreplace "bootstrap.sh", "using python", "#using python"

    Language::Python.each_python(build) do |python, version|
      py_prefix = `#{python} -c "from __future__ import print_function; import sys; print(sys.prefix)"`.strip
      py_include = `#{python} -c "from __future__ import print_function; import distutils.sysconfig; print(distutils.sysconfig.get_python_inc(True))"`.strip
      open("user-config.jam", "w") do |file|
        # Force boost to compile with the desired compiler
        file.write "using darwin : : #{ENV.cxx} ;\n"
        file.write <<-EOS.undent
          using python : #{version}
                       : #{python}
                       : #{py_include}
                       : #{py_prefix}/lib ;
        EOS
      end

      system "./bootstrap.sh", "--prefix=#{prefix}", "--libdir=#{lib}", "--with-libraries=python",
                               "--with-python=#{python}", "--with-python-root=#{py_prefix}"

      system "./b2", "--build-dir=build-#{python}", "--stagedir=stage-#{python}",
                     "python=#{version}", *args
    end

    lib.install Dir["stage-python3/lib/*py*"] if build.with?("python3")
    lib.install Dir["stage-python/lib/*py*"] if build.with?("python")
    doc.install Dir["libs/python/doc/*"]
  end

  test do
    (testpath/"hello.cpp").write <<-EOS.undent
      #include <boost/python.hpp>
      char const* greet() {
        return "Hello, world!";
      }
      BOOST_PYTHON_MODULE(hello)
      {
        boost::python::def("greet", greet);
      }
    EOS
    Language::Python.each_python(build) do |python, _|
      pyflags = (`#{python}-config --includes`.strip +
                 `#{python}-config --ldflags`.strip).split(" ")
      system ENV.cxx, "-shared", "hello.cpp", "-lboost_#{python}", "-o", "hello.so", *pyflags
      output = `#{python} -c "from __future__ import print_function; import hello; print(hello.greet())"`
      assert_match "Hello, world!", output
    end
  end
end
