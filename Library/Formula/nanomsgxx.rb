class Nanomsgxx < Formula
  desc "Nanomsg binding for C++11"
  homepage "https://achille-roussel.github.io/nanomsgxx/doc/nanomsgxx.7.html"
  url "https://github.com/achille-roussel/nanomsgxx/archive/0.1.tar.gz"
  sha256 "50f6d2507f264f048e0234e78bbbfe80004d636d990fefc4e1f53a5434c4aa63"

  option "with-debug", "Compile with debug symbols"

  depends_on "pkg-config" => :build
  depends_on :python

  if build.with? "debug"
    depends_on "nanomsg" => "with-debug"
  else
    depends_on "nanomsg"
  end

  def install
    args = %W[
      --static
      --shared
      --prefix=#{prefix}
    ]

    args << "--debug" if build.with? "debug"

    system "python", "./waf", "configure", *args
    system "python", "./waf", "build"
    system "python", "./waf", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
#include <iostream>\nint main(int argc, char **argv) {\n\tstd::cout << "Hello Nanomsgxx!" << std::endl;\n}
    EOS

    system "c++", "-std=c++11", "-lnnxx", "test.cpp"

    assert_equal "Hello Nanomsgxx!\n",
        shell_output("#{testpath}/a.out")
  end
end
