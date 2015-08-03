class RestShell < Formula
  desc "Shell to work with Spring HATEOAS-compliant REST resources"
  homepage "https://github.com/spring-projects/rest-shell"
  url "http://download.gopivotal.com/rest-shell/1.2.1/rest-shell-1.2.1.RELEASE.tar.gz"
  version "1.2.1.RELEASE"
  sha256 "0ecfa67d005cc0d51e7a3a26c4dacc53aa12012f0e757332a2fa40c5e780c2d6"

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/rest-shell"
  end

  test do
    system "#{bin}/rest-shell"
  end
end
