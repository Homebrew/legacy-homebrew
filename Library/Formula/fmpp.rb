class Fmpp < Formula
  desc "FMPP is a text file preprocessing tool using FreeMarker templates."
  homepage "http://fmpp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/fmpp/fmpp/0.9.15/fmpp_0.9.15.tar.gz"
  sha256 "b893451b5450a7f35fe680e934f6903ec8143d88959dcfca5d17467fbe4142f9"
  head "https://github.com/freemarker/fmpp.git"

  bottle :unneeded

  depends_on :java

  def install
    libexec.install "lib"
    bin.write_jar_script libexec/"lib/fmpp.jar", "fmpp", "-Dfmpp.home=#{libexec} $FMPP_OPTS $FMPP_ARGS"
  end

  test do
    (testpath/"input").write '<#assign foo="bar"/>${foo}'
    system bin/"fmpp", "input", "-o", "output"
    assert File.exist? "output"
    assert_equal("bar", File.read("output"))
  end
end
