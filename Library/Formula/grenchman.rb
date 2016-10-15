require "formula"

class Grenchman < Formula
  homepage "http://leiningen.org/grench.html"
  url "https://grenchman.s3.amazonaws.com/downloads/grench-0.2.0-mac"
  sha1 "a1468c2e31deeeaf9925c6a3d1ebf9b3aac96521"

  bottle do
    cellar :any
    sha1 "a9e9a5fc87da881ee9c004a3468d1eb7fba69156" => :lion
  end

  def install
    bin.install 'grench-0.2.0-mac' => 'grench'
  end

end
