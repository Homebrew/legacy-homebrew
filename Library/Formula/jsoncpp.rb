require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Jsoncpp < Formula
  homepage 'http://jsoncpp.sourceforge.net'

  url 'http://downloads.sourceforge.net/project/jsoncpp/jsoncpp/0.5.0/jsoncpp-src-0.5.0.tar.gz'
  sha1 '7169a50c7615070b6190076a7b5e86c45b7440b7'

  depends_on 'scons' => :build

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    gccversion = `g++ -dumpversion`

    gccversion = gccversion.delete("\n");

    system "scons platform=linux-gcc"

    system "mkdir -p lib include/include"

    system "ln -sf libs/linux-gcc-#{gccversion}/libjson_linux-gcc-#{gccversion}_libmt.a lib/libjsoncpp.a"

    system "ln -sf libs/linux-gcc-#{gccversion}/libjson_linux-gcc-#{gccversion}_libmt.dylib lib/libjsoncpp.dylib"

    system "cp -r include/json include/include/jsoncpp"

    prefix.install Dir["lib"], Dir["include/include"]
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test jsoncpp`.
    system "false"
  end
end
