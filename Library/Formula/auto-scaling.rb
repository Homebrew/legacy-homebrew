require 'formula'

class AutoScaling < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/2535'
  url 'http://ec2-downloads.s3.amazonaws.com/AutoScaling-2011-01-01.zip'
  version  '1.0.61.6'
  sha1 '2e3aaaa2567f4dcafcedbfc05678270ab02ed341'

  def install
    standard_install
  end

  def caveats
    <<-EOS.undent
      Before you can use these tools you must populate a file and export some variables to your $SHELL.

      You must create a credential file containing:

      AWSAccessKeyId=<Your AWS Access ID>
      AWSSecetKey=<Your AWS Secret Key>

      Then to export the needed variables, add them to your dotfiles.
       * On Bash, add them to `~/.bash_profile`.
       * On Zsh, add them to `~/.zprofile` instead.

      export JAVA_HOME="$(/usr/libexec/java_home)"
      export AWS_AUTO_SCALING_HOME="#{libexec}"
      export AWS_CREDENTIAL_FILE="<Path to credential file>"

      See the website for more details:
      http://docs.aws.amazon.com/AutoScaling/latest/DeveloperGuide/UsingTheCommandLineTools.html
    EOS
  end
end
