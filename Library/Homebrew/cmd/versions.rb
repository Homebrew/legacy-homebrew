require 'formula'

module Homebrew extend self

  module Versions
    # yields version, sha for all versions in the git history
    def self.old_versions f
      yielded = []
      f.rev_list.each do |sha|
        version = f.version_for_sha sha
        unless yielded.include? version
          yield version, sha
          yielded << version
        end
      end
    end
  end

  def versions
    raise "Please `brew install git` first" unless system "/usr/bin/which -s git"

    ARGV.formulae.all? do |f|
      old_versions = Versions.old_versions f do |version, sha|
        print Tty.white
        print "#{version.ljust(8)} "
        print Tty.reset
        puts "git checkout #{sha} #{f.pretty_relative_path}"
      end
    end
  end

end


class Formula
  def rev_list
    Dir.chdir HOMEBREW_REPOSITORY do
      `git rev-list --abbrev-commit HEAD Library/Formula/#{name}.rb`.split
    end
  end

  def sha_for_version version
    revlist.find{ |sha| version == version_for(sha) }
  end

  def version_for_sha sha
    # TODO really we should open a new ruby instance and parse the formula
    # class and then get the version but this would be too slow (?)

    code = Dir.chdir(HOMEBREW_REPOSITORY) do
      `git show #{sha}:Library/Formula/#{name}.rb`
    end

    version = code.match(/class #{Formula.class_s name} < ?Formula.*?(?:version\s|@version\s*=)\s*(?:'|")(.+?)(?:'|").*?end\s/m)
    return version[1] unless version.nil?

    url = code.match(/class #{Formula.class_s name} < ?Formula.*?(?:url\s|@url\s*=)\s*(?:'|")(.+?)(?:'|").*?end\s/m)
    return Pathname.new(url[1]).version unless url.nil?

    head = code.match(/class #{Formula.class_s name} < ?Formula.*?head\s'(.*?)'.*?end\s\s/m)
    return 'HEAD' unless head.nil?

    opoo "Version of #{name} could not be determined for #{sha}."
  end

  def pretty_relative_path
    if Pathname.pwd == HOMEBREW_REPOSITORY
      "Library/Formula/#{name}.rb"
    else
      "#{HOMEBREW_REPOSITORY}/Library/Formula/#{name}.rb"
    end
  end
end
