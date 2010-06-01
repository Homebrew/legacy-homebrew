require 'formula'

# Require ec2-api-tools to get the base class
require "#{File.dirname __FILE__}/ec2-api-tools.rb"

class RdsCommandLineTools <AmazonWebServicesFormula
  homepage 'http://developer.amazonwebservices.com/connect/entry.jspa?externalID=2928'
  url      'http://s3.amazonaws.com/rds-downloads/RDSCli.zip'
  md5      'a4c7f9efca4c19b9f9073945a5bbc7b9'
  version  '1.1.005'

  def install
    standard_install
  end

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
