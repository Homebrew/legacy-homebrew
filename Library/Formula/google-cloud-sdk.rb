require 'formula'

class Google < Formula
  homepage 'https://developers.google.com/cloud/sdk/'
  url 'https://dl.google.com/dl/cloudsdk/google-cloud-sdk-0.9.5-mac-python.zip'
  sha1 '5f22c396b4d03dd02e9d15083eb70eb811a4d62d'

  def install
    standard_install
  end

end
