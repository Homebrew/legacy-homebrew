require "formula"

class JoobyBootstrap < Formula
  homepage "https://github.com/jooby-project/jooby-bootstrap"
  url "https://github.com/jooby-project/jooby-bootstrap/archive/0.2.2.tar.gz"
  sha1 "54802aa2a7bad6a07f25fc4d1dc35767c3525deb"

  depends_on :java => "1.8"
  depends_on "maven"

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
    system "#{bin}/jooby", "version"
  end
end
