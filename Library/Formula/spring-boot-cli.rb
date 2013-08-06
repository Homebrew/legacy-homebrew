require 'formula'

class SpringBootCli < Formula
  homepage 'https://github.com/SpringSource/spring-boot'
  url 'https://repo.springsource.org/milestone/org/springframework/boot/spring-boot-cli/0.5.0.M1/spring-boot-cli-0.5.0.M1.jar'
  version '0.5.0.M1'
  sha1 'b613bd871a2aebd7e705b7c0d549de8218008247'

  def install
    libexec.install 'spring-boot-cli-0.5.0.M1.jar'
    bin.write_jar_script libexec/'spring-boot-cli-0.5.0.M1.jar', 'spring'
  end
end
