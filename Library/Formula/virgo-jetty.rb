require 'formula'

# Require virgo-tomcat to get base class
require "#{File.dirname __FILE__}/virgo-tomcat.rb"

class VirgoJetty < VirgoStandard

  homepage "http://www.eclipse.org/virgo/"
  # don't delete empty repository folders and work directory
  skip_clean :all
  version "3.0.0.M05"

  # have to add &dummy so file name is correct when downloaded
  url "http://www.eclipse.org/downloads/download.php?r=1&protocol=http&file=/virgo/milestone/VJS/#{version}/virgo-jetty-server-#{version}.zip"
  md5 '9b0f8119f28b2e8137e6cc748241ec19'

  def install
    standard_install 'jetty'
  end

end
