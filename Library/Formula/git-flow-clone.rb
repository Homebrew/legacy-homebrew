require 'formula'

class GitFlowClone < Formula
  homepage 'https://github.com/ashirazi/git-flow-clone'
  url 'https://github.com/ashirazi/git-flow-clone/archive/0.1.2.tar.gz'
  sha1 'd4d5c106ebd7de8abbee69f0b277ecdfe85e5b6d'

  def self.git_flow_avh_present?
    [Dependency.new("git-flow-avh")].detect do |dep|
      dep.installed? or dep.requested?
    end
  end

  if git_flow_avh_present?
    depends_on 'git-flow-avh'
  else
    depends_on 'git-flow'
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
