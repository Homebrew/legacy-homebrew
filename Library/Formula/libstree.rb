require "formula"

class Libstree < Formula
  homepage "http://www.icir.org/christian//libstree/index.html"
  url "http://www.icir.org/christian/downloads/libstree-0.4.2.tar.gz"
  sha1 "b35bc18fbbc43bec1415bc1d884708e1df7bf2c6"

  # Patch required to fix OS X build - use existing MacPorts patch
  # see: https://trac.macports.org/ticket/17648
  #      https://trac.macports.org/changeset/43797
  patch :p0 do
    url "https://trac.macports.org/export/43797/trunk/dports/science/libstree/files/patch-src__lst_string.h"
    sha1 "ed85cbd226027733011d702f95dfb54da90e3b8d"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"

    # create and install dynamiclib and symlink
    system "cd src/.libs && gcc -fno-common -dynamiclib -o libstree.0.0.0.dylib -current_version 0.0.0 -install_name #{prefix}/lib/libstree.0.0.0.dylib *.o"
    lib.install_symlink "libstree.0.0.0.dylib" => "libstree.dylib"
    lib.install "src/.libs/libstree.0.0.0.dylib"

    prefix.install "test"
  end

  test do
    test_string = "foo bar baz qux"
    test_file = testpath/"libstree-test.txt"
    test_file.write <<-EOS.undent
      Hello Homwbrew
    EOS

    output = `#{prefix}/test/addremovetest #{test_string} 2>&1`
    assert $?.success?
    assert_match /^After removing foo/, output

    output = `#{prefix}/test/addtest #{test_string} 2>&1`
    assert $?.success?
    assert_match /^Tree after all insertions:/, output

    output = `#{prefix}/test/buildtest #{test_string} 2>&1`
    assert $?.success?
    assert_match /^Tree after all insertions:/, output

    output = `#{prefix}/test/deltest #{test_string} 2>&1`
    assert $?.success?
    assert_match /^After removing string 'foo'/, output

    output = `#{prefix}/test/lcstext 1 2 foo fooo foooo foooo 2>&1`
    assert $?.success?
    assert_match /^fo oo\s$/, output

    output = `#{prefix}/test/lrstext 1 2 #{test_string} 2>&1`
    assert $?.success?
    assert_match /^ba\s$/, output

    output = `#{prefix}/test/lcshex #{test_file} 2>&1`
    assert $?.success?
    assert_match /^48 65 6C 6C 6F 20 48 6F 6D 77 62 72 65 77 0A\s$/, output
  end

end
