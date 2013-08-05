require 'formula'

class SpringBootCli < Formula
  homepage 'https://github.com/SpringSource/spring-boot'
  url 'https://repo.springsource.org/milestone/org/springframework/boot/spring-boot-cli/0.5.0.M1/spring-boot-cli-0.5.0.M1.jar'
  version '0.5.0.M1'
  sha1 'd620af87d6a253a4577118c018c320b8f299a399'

  def install
    libexec.install 'spring-boot-cli-0.5.0.M1.jar'
    (buildpath/'spring').write <<-EOS.undent
      #!/bin/sh
      java -jar #{libexec}/spring-boot-cli-0.5.0.M1.jar $*
    EOS
    bin.install('spring')
  end

end
