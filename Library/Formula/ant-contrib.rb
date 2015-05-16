require "formula"

class AntContrib < Formula
  homepage "http://ant-contrib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ant-contrib/ant-contrib/1.0b3/ant-contrib-1.0b3-bin.tar.gz"
  sha1 "05b74808d51f501a993457fb9b7871484acba901"
  version "1.0b3"

  depends_on "ant"

  def install
    libexec.install "lib", "ant-contrib-1.0b3.jar"
    share.install "docs"
  end

  test do
    (testpath/"build.xml").write <<-EOS.undent
      <project name="HomebrewTest" default="init" basedir=".">
        <taskdef resource="net/sf/antcontrib/antcontrib.properties"/>
        <target name="init">
          <if>
            <equals arg1="BREW" arg2="BREW" />
            <then>
              <echo message="Test passes!"/>
            </then>
          </if>
        </target>
      </project>
    EOS
    system Formula["ant"].opt_bin/"ant", "-lib", libexec
  end
end
