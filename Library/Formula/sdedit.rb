class Sdedit < Formula
  desc "Tool for generating sequence diagrams very quickly."
  homepage "http://sdedit.sourceforge.net"
  url "https://downloads.sourceforge.net/project/sdedit/sdedit/4.0/sdedit-4.01.jar"
  sha256 "060576f9fe79bda0a65f2cfa0b041fceaf7846f034a7519ef939b73ae82673f1"

  bottle :unneeded

  depends_on :java => "1.5+"

  def install
    libexec.install "sdedit-#{version}.jar"
    bin.write_jar_script libexec/"sdedit-#{version}.jar", "sdedit"
  end

  test do
    (testpath/"test.sd").write <<-EOS.undent
      #![SD ticket order]
      ext:External[pe]
      user:Actor
    EOS
    system "java", "-jar", "#{libexec}/sdedit-#{version}.jar", "-t", "pdf",
        "-o", testpath/"test.pdf", testpath/"test.sd"
  end
end
