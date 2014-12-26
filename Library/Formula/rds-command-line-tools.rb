require 'formula'

class RdsCommandLineTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/2928'
  url 'https://s3.amazonaws.com/rds-downloads/RDSCli-1.14.001.zip'
  sha1 'd0853f066ba1dca699a4a1d91581e11e523ec83a'

  def caveats
    s = standard_instructions "AWS_RDS_HOME"
    s += <<-EOS.undent

      To check that your setup works properly, run the following command:
        rds-describe-db-instances --headers

      You should see a header line. If you have database instances already configured,
      you will see a description line for each database instance.
    EOS
    return s
  end
end
