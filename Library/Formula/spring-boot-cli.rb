require 'formula'

class SpringBootCli < Formula
  homepage 'https://github.com/SpringSource/spring-boot'
  version '0.5.0.M1'
  url 'https://repo.springsource.org/milestone/org/springframework/boot/spring-boot-cli/%s/spring-boot-cli-%s.jar' % [version, version]
  sha1 'd620af87d6a253a4577118c018c320b8f299a399'

  def install
    libexec.install('spring-boot-cli-%s.jar' % version)
    File.open('spring', 'w') { |file|
      file.write("#!/bin/sh\n")
      file.write("java -jar /usr/local/Cellar/spring-boot-cli/%s/libexec/spring-boot-cli-%s.jar \$*\n" % [version, version])
    }
    bin.install('spring')
  end

end
