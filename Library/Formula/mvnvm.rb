require "formula"

# Homebrew formula to install mvnvm, the Maven Version Manager, see http://mvnvm.org

class Mvnvm < Formula
  homepage "http://mvnvm.org"
  url "https://bitbucket.org/mjensen/mvnvm/get/master.tar.gz"
  version "0.2"  # Bump this and update the sha1 below when master contains a change to distribute
  sha1 "8145a8965ea72dcb2b61737ba94a1a7cd6cf3360" # brew install tells us if this is wrong or missing

  def install
    bin.install "mvn" # Sets the executable flag for us
    ohai "If you previously installed mvnvm manually, please remove it using `rm -f ~/bin/mvn`"
    ohai "And if you have any other Maven installations on your path, remove them too."
    ohai ""
    ohai "Running `mvn -version` should now output something like `[MVNVM] Using maven: x.y.z`, etc."
  end

  conflicts_with 'maven',
    :because => 'instead of installing Maven via Homebrew, you should use mvnvm to manage your Maven versions.'

  test do
    # Run the test with `brew test mvnvm`
    # A better test would be checking that the output of the command below
    # starts with `[MVNVM] Using maven:`, but I'm not sure how to do that.
    system "mvn", "-version"
  end
end
