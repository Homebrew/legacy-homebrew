require 'formula'

$cake_version = "0.6.2"

# Downloads executable
class CakeExecutable < Formula
  url     "http://releases.clojure-cake.org/cake"
  md5     "d5533fc60a264d5db47f9801882a45c1"
  version $cake_version
end

# Cake jars, installs executable
class Cake < Formula
  url       "http://releases.clojure-cake.org/jars/cake-#{$cake_version}.jar"
  head      "git://github.com/ninjudd/cake.git", :using => :git
  homepage  "http://github.com/ninjudd/cake"
  md5       "2785a2614267e636b5ef889bda0a15e6"

  def install
    if ARGV.build_head?
      bin.install "bin/cake" # only need executable if HEAD
    else
      libexec.install "cake-#{$cake_version}.jar" => "cake.jar"

      # extract bake.jar
      libexec.cd do
        system "jar xf cake.jar bake.jar"
      end

      # get executable
      CakeExecutable.new.brew do
        bin.install "cake"
      end
    end
  end

  def caveats; <<-EOS.undent
      Using snapshot version.  Standalone jar and dependencies will be installed to:
        $HOME/.m2/repository
      the first time cake is run.
    EOS
  end if ARGV.build_head?
end
