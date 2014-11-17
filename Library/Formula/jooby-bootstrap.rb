require "formula"

# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class JoobyBootstrap < Formula
  homepage "https://github.com/jooby-project/jooby-bootstrap"
  url "https://github.com/jooby-project/jooby-bootstrap/archive/0.2.2.tar.gz"
  sha1 "54802aa2a7bad6a07f25fc4d1dc35767c3525deb"

  def install
    bin.install "jooby"
  end

  def caveats; <<-EOS.undent
    Be aware that jooby-boostrap and jooby depend on having maven3 and java8
    installed.

    Java 8 from Oracle is available in brew-cask `brew cask install java`
    Maven 3 is available from the official brew repository `brew install maven`

    You can also choose to install maven and java8 manually, but why would you?

    EOS
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test jooby-bootstrap`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "#{bin}/jooby", 'version"'
  end
end
