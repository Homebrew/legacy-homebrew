class UniversalPython < Requirement
  satisfy(:build_env => false) { archs_for_command("python").universal? }

  def message; <<-EOS.undent
    A universal build was requested, but Python is not a universal build

    Boost compiles against the Python it finds in the path; if this Python
    is not a universal build then linking will likely fail.
    EOS
  end
end

class UniversalPython3 < Requirement
  satisfy(:build_env => false) { archs_for_command("python3").universal? }

  def message; <<-EOS.undent
    A universal build was requested, but Python 3 is not a universal build

    Boost compiles against the Python 3 it finds in the path; if this Python
    is not a universal build then linking will likely fail.
    EOS
  end
end

class BoostPython < Formula
  homepage "http://www.boost.org"
  url "https://downloads.sourceforge.net/project/boost/boost/1.57.0/boost_1_57_0.tar.bz2"
  sha1 "e151557ae47afd1b43dc3fac46f8b04a8fe51c12"
  head "https://github.com/boostorg/boost.git"

  option :universal
  option :cxx11

  depends_on :python => :recommended
  depends_on :python3 => :optional
  depends_on UniversalPython if build.universal? and build.with? "python"
  depends_on UniversalPython3 if build.universal? and build.with? "python3"

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
    Language::Python.each_python(build) do |python, version|
      pycflags = `#{python}-config --includes`.strip
      pyldflags = `#{python}-config --ldflags`.strip
      system "#{ENV.cxx} -shared hello.cpp #{pycflags} #{pyldflags} -lboost_#{python} -o hello.so"
      output = `#{python} -c "from __future__ import print_function; import hello; print(hello.greet())"`
      assert output.include?("Hello, world!")
    end
  end
end
