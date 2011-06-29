require 'formula'

# Require virgo-tomcat to get base class
require "#{File.dirname __FILE__}/virgo-tomcat.rb"

class VirgoKernel < VirgoStandard

  homepage "http://www.eclipse.org/virgo/"
  # don't delete empty repository folders and work directory
  skip_clean :all
  version "3.0.0.M05"

  # have to add &dummy so file name is correct when downloaded
  url "http://www.eclipse.org/downloads/download.php?r=1&protocol=http&file=/virgo/milestone/VK/#{version}/virgo-kernel-#{version}.zip&r=1&dummy=virgo-kernel-#{version}.zip"
  md5 "d6ef460c168dcb9651920e977942e0e3"
  def install
    standard_install 'kenel'
  end

end
