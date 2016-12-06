require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Clojurescript < Formula
  homepage 'https://github.com/clojure/clojurescript/wiki'
  url 'https://github.com/clojure/clojurescript/archive/r1552.tar.gz'
  version '1552'
  sha1 'b1d46005cfaf5edc941e9f19169401b63e4e1c44'


  def install
    system "mkdir -p lib"
    install_clojure
    install_library
    install_compiler
    install_rhino_js
    system "cp closure/compiler/compiler.jar lib"
    system "cp -R ./ #{prefix}"
  end

  def install_clojure
    ohai "Fetching clojure"
    system "curl -O -s http://repo1.maven.org/maven2/org/clojure/clojure/1.4.0/clojure-1.4.0.zip"
    system "unzip -qu clojure-1.4.0.zip"
    ohai "copying clojure.jar"
    system "cp clojure-1.4.0/clojure-1.4.0.jar lib/clojure.jar"
    ohai "cleaning up clojure"
    system "rm -rf clojure-1.4.0"
    system "rm clojure-1.4.0.zip"
  end

  def install_library
    system "mkdir -p closure/library"
    Dir.chdir("closure/library") do
      ohai "Fetching Closure library"
      closure_library = "closure-library-20120710-r2029.zip"
      system "curl -O -s 'http://closure-library.googlecode.com/files/#{closure_library}'"
      system "unzip -qu #{closure_library}"
      ohai "Cleaning up Closure library"
      system "rm #{closure_library}"
    end
  end

  def install_compiler
    system "mkdir -p closure/compiler"
    Dir.chdir("closure/compiler") do
      ohai "Fetching Closure compiler"
      system "curl -O -s http://closure-compiler.googlecode.com/files/compiler-latest.zip"
      system "unzip -qu compiler-latest.zip"
      ohai "Cleaning up the compiler"
      system "rm compiler-latest.zip"
    end
    ohai "Building the compiler"
    system "jar cf ./lib/goog.jar -C closure/library/closure/ goog"
  end
  
  def install_rhino_js
    ohai "Fetching Rhino"
    system "curl -O -s http://ftp.mozilla.org/pub/mozilla.org/js/rhino1_7R3.zip"
    system "unzip -qu rhino1_7R3.zip"
    system "cp rhino1_7R3/js.jar lib/js.jar"
    ohai "Cleaning up Rhino"
    system "rm -rf rhino1_7R3"
    system "rm rhino1_7R3.zip"
  end

  def test
  end
end
